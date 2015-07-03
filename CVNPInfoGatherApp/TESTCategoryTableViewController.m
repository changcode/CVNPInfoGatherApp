//
//  TESTCategoryTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/1/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "TESTCategoryTableViewController.h"
#import "CVNPCategoryModel.h"
#import "CVNPSqliteManager.h"

@interface TESTCategoryTableViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, nonatomic) CVNPCategoryModel *current;
@property (strong, nonatomic) CVNPSqliteManager *DAO;

@end

@implementation TESTCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_current.Cat_Name == nil || [_current.Cat_Name isEqualToString:@""]) {
        self.title = @"Root";
    } else {
        self.title = _current.Cat_Name;
    }
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.delegate = self;
    
    _DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"Test"];
    [self.manager addSection:section];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [CVNPCategoryModel PullCategoriesFromRemote:^(NSArray *AllCategories, NSError *error) {
        for (CVNPCategoryModel *cate in AllCategories) {
            if (_current.Cat_ID == nil && [cate.Cat_Parent_ID isEqualToString:@"0"]) {
                [section addItem:[RETableViewItem itemWithTitle:cate.Cat_Name accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                    TESTCategoryTableViewController * controller = [[TESTCategoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                    controller.current = cate;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }]];
            }
            if ([cate.Cat_Parent_ID isEqualToString:_current.Cat_ID] ) {
                [section addItem:[RETableViewItem itemWithTitle:cate.Cat_Name accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
                    TESTCategoryTableViewController * controller = [[TESTCategoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                    controller.current = cate;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                    NSLog(@"%@",cate.Cat_ID);
                }]];
            }
        }
        
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
