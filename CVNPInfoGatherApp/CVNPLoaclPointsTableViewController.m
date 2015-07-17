//
//  CVNPLoaclPointsTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/9/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//
#import "AFNetworking.h"
#import "Config.h"

#import "CVNPLoaclPointsTableViewController.h"
#import "CVNPPointsModel.h"
#import "CVNPSqliteManager.h"

//#import "CVNPPointDetailViewController.h"
#import "CVNPPointModifyTableViewController.h"
#import "UIAlertView+AFNetworking.h"
#import "UIRefreshControl+AFNetworking.h"

#import "MBProGressHUD.h"

@interface CVNPLoaclPointsTableViewController () <UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapButtton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *syncButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dataSourceSegmentedControl;

@property (strong, nonatomic) MBProgressHUD * HUD;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *tempDataArray;
@property (strong, nonatomic) CVNPSqliteManager *DAO;
@end

@implementation CVNPLoaclPointsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    [_HUD hide:YES];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    self.dataArray = [[NSMutableArray alloc] initWithArray:[self.DAO QueryAllLocal]];
    [self updateButtonsToMatchTableState];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reload:nil];
}

#pragma mark - Action methods
- (void)reload:(__unused id)sender {
    if (_dataSourceSegmentedControl.selectedSegmentIndex == 0) {
        [_HUD show:YES];
        _HUD.mode = MBProgressHUDModeIndeterminate;
        _HUD.labelText = @"Finishing...";
        self.dataArray = [[NSMutableArray alloc] initWithArray:[self.DAO QueryAllLocal]];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [_HUD hide:YES];
    }
    if (_dataSourceSegmentedControl.selectedSegmentIndex == 1) {
        NSURLSessionTask *task = [CVNPPointsModel User: [Config getOwnID] withRemotePointsWithBlock:^(NSArray *points, NSError *error) {
            if (!error) {
                self.dataArray = [[NSMutableArray alloc] initWithArray:points];
                [self.tableView reloadData];
            }
        }];
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
        [self.refreshControl setRefreshingWithStateOfTask:task];
    }
}

- (IBAction)dataSourceSegment:(id)sender {
    if (_dataSourceSegmentedControl.selectedSegmentIndex == 0) {
        [self reload:sender];
        [self updateButtonsToMatchTableState];
    }
    if (_dataSourceSegmentedControl.selectedSegmentIndex == 1) {
        [self reload:sender];
        [self updateButtonsToMatchTableState];
    }
}
- (IBAction)mapAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editAction:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
}

- (IBAction)cancelAction:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    [self updateButtonsToMatchTableState];
}

- (IBAction)deleteAction:(id)sender {
    
    NSString *actionTitle;
    if (([[self.tableView indexPathsForSelectedRows] count] == 1)) {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove this item?", @"");
    }
    else
    {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove these items?", @"");
    }
    
    NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel title for item removal action");
    NSString *okTitle = NSLocalizedString(@"OK", @"OK title for item removal action");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle
                                                             delegate:self
                                                    cancelButtonTitle:cancelTitle
                                               destructiveButtonTitle:okTitle
                                                    otherButtonTitles:nil];
    [actionSheet setTag:1];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    // Show from our table view (pops up in the middle of the table).
    [actionSheet showInView:self.view];
}

- (IBAction)syncAction:(id)sender {
    UIAlertView *confirmSync = [[UIAlertView alloc] initWithTitle:@"Synchronize will start" message:@"This action will download all points on server and upload all new points in local" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Synchronize", nil];
    [confirmSync show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        _HUD.labelText = @"Sync...";
        _HUD.dimBackground = YES;
        _HUD.userInteractionEnabled = NO;
        [_HUD show:YES];
        
        _HUD.labelText = @"Uploading...";
        for (CVNPPointsModel *Point in _dataArray) {
            Point.User_ID = [Config getOwnID];
            _HUD.labelText = [NSString stringWithFormat:@"Upload %d/Total %d",[_dataArray indexOfObject:Point], [_dataArray count]];
            if (!Point.isUpdated) {
                AFHTTPRequestOperation *operation = [CVNPPointsModel UserUpload:[Config getOwnID] Points:Point withRemotePointsWithBlock:^(NSString *pointID, NSError *error) {
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
                        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:[_dataArray indexOfObject:Point] inSection:0];
                        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
                        [self.DAO UpdateLocalById:[Point.Local_ID intValue] newPoint:Point];
                        [self reload:nil];
                    }
                }];
                [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                    float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
                    _HUD.mode = MBProgressHUDModeDeterminate;
                    _HUD.labelText = [NSString stringWithFormat:@"This is %d, %lf finished",[_dataArray indexOfObject:Point], progress];
                    _HUD.progress = progress;
                    NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
                }];
                [operation start];
            }
        }
        
        _HUD.labelText = @"Pulling...";
        [CVNPPointsModel User: [Config getOwnID] withRemotePointsWithBlock:^(NSArray *points, NSError *error) {
            if (!error) {
                _HUD.labelText = @"Writing...";
                _tempDataArray = [[NSMutableArray alloc] initWithArray:points];
                for (CVNPPointsModel * sycnPoint in _tempDataArray) {
                    [_DAO SyncFromRemote:sycnPoint];
                }
                [self reload:nil];
            }
        }];
    }
    else
    {
        //        NSLog(@"cancel");
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoCVNPPointModifyTableViewController"]) {
        CVNPPointModifyTableViewController *pdvc = segue.destinationViewController;
        [pdvc setCurrentPoint:(CVNPPointsModel *)sender];
        pdvc.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
            BOOL deletSpecificRows =selectedRows.count > 0;
            if (deletSpecificRows) {
                // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
                NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
                
                
                for (NSIndexPath *selectionIndex in selectedRows)
                {
                    [indicesOfItemsToDelete addIndex:selectionIndex.row];
                }
                
                NSArray *indicesOfItemsInDAO = [self.dataArray objectsAtIndexes:indicesOfItemsToDelete];
                NSMutableArray *delIDs = [[NSMutableArray alloc] init];
                
                for (CVNPPointsModel *delPoint in indicesOfItemsInDAO) {
                    [delIDs addObject:[delPoint Local_ID]];
                }
                [self.DAO DeleteLocalByIds:delIDs];
                
                // Delete the objects from our data model.
                [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
                
                // Tell the tableView that we deleted the objects
                [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [self.dataArray removeAllObjects];
                [self.DAO DeleteAllLocations];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self.tableView setEditing:NO animated:YES];
            [self updateButtonsToMatchTableState];
        }
    }
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            [self updateButtonsToMatchTableState];
        }
    }

}



#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [self updateButtonsToMatchTableState];
    if (!self.tableView.editing) {
        [self performSegueWithIdentifier:@"GoCVNPPointModifyTableViewController" sender:[self.dataArray objectAtIndex:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [self updateDeleteButtonTitle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] Title];
    cell.detailTextLabel.text = [[self.dataArray objectAtIndex:indexPath.row] Description];
    cell.userInteractionEnabled = ![[self.dataArray objectAtIndex:indexPath.row] isUpdated];
    if ([[self.dataArray objectAtIndex:indexPath.row] isUpdated]) {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [cell setAccessoryView:activityView];
    }
    return cell;
}

#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState
{
    if (_dataSourceSegmentedControl.selectedSegmentIndex == 0) {
        if (self.tableView.editing)
        {
            self.navigationItem.rightBarButtonItems = nil;
            self.navigationItem.rightBarButtonItem = self.cancelButton;
            
            [self updateDeleteButtonTitle];
            
            self.navigationItem.leftBarButtonItem = self.deleteButton;
        }
        else
        {
            // Not in editing mode.
            self.navigationItem.leftBarButtonItem = _mapButtton;
            // Show the edit button, but disable the edit button if there's nothing to edit.
            
            if (self.dataArray.count > 0)
            {
                self.editButton.enabled = YES;
            }
            else
            {
                self.editButton.enabled = NO;
            }

            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: _syncButton, _editButton, nil];
        }
    }
    if (_dataSourceSegmentedControl.selectedSegmentIndex == 1) {
        self.navigationItem.leftBarButtonItem = _mapButtton;
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = _editButton;
        self.editButton.enabled = NO;
    }
}

- (void)updateDeleteButtonTitle
{
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == self.dataArray.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (allItemsAreSelected || noItemsAreSelected)
    {
        self.deleteButton.title = NSLocalizedString(@"Delete All", @"");
    }
    else
    {
        NSString *titleFormatString =
        NSLocalizedString(@"Delete (%d)", @"Title for delete button with placeholder for number");
        self.deleteButton.title = [NSString stringWithFormat:titleFormatString, selectedRows.count];
    }
}
@end
