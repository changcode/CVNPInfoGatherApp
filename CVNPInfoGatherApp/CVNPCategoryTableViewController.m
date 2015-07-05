//
//  CVNPCategoryTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/2/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPCategoryTableViewController.h"


@interface CVNPCategoryTableViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
@property (strong, nonatomic) NSArray *currentlevelitems;

@property (strong, nonatomic) CVNPSqliteManager *DAO;
@property (strong, nonatomic) RETableViewManager *manager;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation CVNPCategoryTableViewController
- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    _currentlevelitems = [NSArray arrayWithArray:[_DAO QueryChildCategoriesByCate:_parentCategory]];
    
    if (self.level == 0) {
        _searchController = [[UISearchController alloc] init];
        self.searchController.searchResultsUpdater = self;
        [self.searchController.searchBar sizeToFit];
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    
    self.title = _parentCategory.Cat_Name;
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];

    RETableViewSection *section = [RETableViewSection section];
    
    __typeof (&*self) __weak weakSelf = self;
    
    for (CVNPCategoryModel *cate in _currentlevelitems) {
        BOOL hasChildren = [_DAO JudgeCategriesHasChildren:cate];
        if (hasChildren) {
            [section addItem:[RETableViewItem itemWithTitle:cate.Cat_Name accessoryType: UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                CVNPCategoryTableViewController *controller = [[CVNPCategoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [item deselectRowAnimated:YES];
                controller.level = _level + 1;
                controller.parentCategory = cate;
                controller.delegate = weakSelf.navigationController.viewControllers[0];
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }]];
        } else {
            
            [section addItem:[RETableViewItem itemWithTitle:cate.Cat_Name accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                item.accessoryType = UITableViewCellAccessoryCheckmark;
                [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                if ([weakSelf.delegate respondsToSelector:@selector(getSelectCategory:)]) {
                    [weakSelf.delegate getSelectCategory:cate.Cat_Name];
                }
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                NSLog(@"Selected:%@", cate.Cat_Name);
            }]];
        }
    }
    [self.manager addSection:section];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
