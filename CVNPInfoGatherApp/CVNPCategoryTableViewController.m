//
//  CVNPCategoryTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/2/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPCategoryTableViewController.h"


@interface CVNPCategoryTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) CVNPSqliteManager *DAO;

@property (strong, nonatomic) RETableViewManager *manager;
@property (strong, nonatomic) RETableViewSection *section;

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation CVNPCategoryTableViewController
- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    
    if (self.level == 0) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        [self.searchController.searchBar sizeToFit];
        self.tableView.tableHeaderView = self.searchController.searchBar;
        self.searchController.delegate = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        self.definesPresentationContext = YES;
    }
    
    self.title = _parentCategory.Cat_Name;
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];

    self.section = [RETableViewSection section];
    
    [self test:self.searchController];
    [self.manager addSection:self.section];
    
    [self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    NSLog(@"Updaing result controller searchController:%@", searchController.active ? @"YES" : @"NO");
    [self test:searchController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)test:(UISearchController *)searchController
{
    __typeof (&*self) __weak weakSelf = self;
    if (!self.searchController.active) {
        NSArray * currentlevelitems = [NSArray arrayWithArray:[_DAO QueryChildCategoriesByCate:_parentCategory]];

        [self.section removeAllItems];
        
        for (CVNPCategoryModel *cate in currentlevelitems) {
            BOOL hasChildren = [_DAO JudgeCategriesHasChildren:cate];
            if (hasChildren) {
                [self.section addItem:[RETableViewItem itemWithTitle:cate.Cat_Name accessoryType: UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                    CVNPCategoryTableViewController *controller = [[CVNPCategoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [item deselectRowAnimated:YES];
                    controller.level = _level + 1;
                    controller.parentCategory = cate;
                    controller.delegate = weakSelf.navigationController.viewControllers[0];
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }]];
            } else {
                
                [self.section addItem:[RETableViewItem itemWithTitle:cate.Cat_Name accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                    item.accessoryType = UITableViewCellAccessoryCheckmark;
                    [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                    if ([weakSelf.delegate respondsToSelector:@selector(getSelectCategory:)]) {
                        [weakSelf.delegate getSelectCategory:cate];
                    }
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    NSLog(@"Selected:%@", cate.Cat_Name);
                }]];
            }
        }
        [self.tableView reloadData];
    } else {
        NSArray * searchitems = [NSArray arrayWithArray:[_DAO QueryAllCategories]];
        NSPredicate *nameContainsPredicate = [NSPredicate predicateWithFormat:@"Cat_Name CONTAINS[cd] %@", searchController.searchBar.text];
        NSArray * searchitemsResult = [NSArray arrayWithArray:[searchitems filteredArrayUsingPredicate:nameContainsPredicate]];
        [self.section removeAllItems];
        [self.tableView reloadData];
        for (CVNPCategoryModel *cate in searchitemsResult) {
            BOOL hasChildren = [_DAO JudgeCategriesHasChildren:cate];
            if (hasChildren) {
                [self.section addItem:[RETableViewItem itemWithTitle:cate.Cat_Name accessoryType: UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                    CVNPCategoryTableViewController *controller = [[CVNPCategoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [item deselectRowAnimated:YES];
                    controller.level = _level + 1;
                    controller.parentCategory = cate;
                    controller.delegate = weakSelf.navigationController.viewControllers[0];
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }]];
            } else {
                [self.section addItem:[RETableViewItem itemWithTitle:cate.Cat_Name accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                    item.accessoryType = UITableViewCellAccessoryCheckmark;
                    [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                    if ([weakSelf.delegate respondsToSelector:@selector(getSelectCategory:)]) {
                        [weakSelf.delegate getSelectCategory:cate];
                    }
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    NSLog(@"Selected:%@", cate.Cat_Name);
                }]];
            }
        }
        [self.tableView reloadData];
    }
}
@end
