//
//  CVNPUploadTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/18/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//
#import "Config.h"
#import "CVNPSqliteManager.h"
#import "CVNPUploadTableViewController.h"

@interface CVNPUploadTableViewController ()
@property (strong, nonatomic) CVNPSqliteManager * DAO;
@property (strong, nonatomic) NSArray * uploadingData;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *uploadItemButton;

@end

@implementation CVNPUploadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    self.uploadingData = [[NSArray alloc] initWithArray:[self.DAO QueryAllLocal]];
    self.navigationItem.rightBarButtonItem = _uploadItemButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_uploadingData count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell" forIndexPath:indexPath];
    cell.textLabel.text = [[_uploadingData objectAtIndex:indexPath.row] Title];

    if ([[_uploadingData objectAtIndex:indexPath.row] isUpdated]) {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [cell setAccessoryView:activityView];
    }
    return cell;
}

- (IBAction)uploadItemButtonPressed:(id)sender {
    for (__block CVNPPointsModel *Point in _uploadingData) {
        Point.User_ID = [Config getOwnID];
        
        if (!Point.isUpdated) {
            [CVNPPointsModel UserUpload:[Config getOwnID] Points:Point withRemotePointsWithBlock:^(NSString *pointID, NSError *error) {
                if (!error) {
                    NSString *serverID = pointID;
                    if ([serverID isEqualToString:@"-1"]) {
                        [Point setServer_ID:@"-1"];
                        [Point setIsUpdated:NO];
                    }
                    else {
                        [Point setServer_ID:serverID];
                        [Point setIsUpdated:YES];
                    }
                    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:[_uploadingData indexOfObject:Point] inSection:0];
                    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
                    
                    [self.DAO UpdateLocalById:[Point.Local_ID intValue] newPoint:Point];

                }
            }];
        }
    }
}

@end