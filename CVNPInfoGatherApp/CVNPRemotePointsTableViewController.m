//
//  CVNPRemotePointsTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/16/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "Config.h"

#import "CVNPRemotePointsTableViewController.h"
#import "CVNPPointsModel.h"

#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"

@interface CVNPRemotePointsTableViewController ()

@property (readwrite, nonatomic, strong) NSArray *posts;

@end

@implementation CVNPRemotePointsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"AFNetworking", nil);
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.tableView.rowHeight = 70.0f;
    [self reload:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.posts objectAtIndex:(NSUInteger)indexPath.row] Title];
    cell.detailTextLabel.text = [[self.posts objectAtIndex:(NSUInteger)indexPath.row] Description];
    return cell;
}

- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSURLSessionTask *task = [CVNPPointsModel User:[Config getOwnID] withRemotePointsWithBlock:^(NSArray *points, NSError *error) {
        if (!error) {
            self.posts = points;
            [self.tableView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}
@end
