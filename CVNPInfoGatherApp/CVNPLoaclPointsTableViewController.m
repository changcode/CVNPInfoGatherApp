//
//  CVNPLoaclPointsTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/9/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPLoaclPointsTableViewController.h"
#import "CVNPSqliteManager.h"

@interface CVNPLoaclPointsTableViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *uploadButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) CVNPSqliteManager *DAO;
@end

@implementation CVNPLoaclPointsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    self.dataArray = [[NSMutableArray alloc] initWithArray:[self.DAO QueryAllLocal]];
    [self updateButtonsToMatchTableState];
}

#pragma mark - Action methods
- (IBAction)uploadAction:(id)sender {
    NSString *actionTitle = NSLocalizedString(@"Are you sure you want to upload all item?", @"");
    NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel title for item upload action");
    NSString *okTitle = NSLocalizedString(@"Upload", @"OK title for item upload action");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle
                                                             delegate:self
                                                    cancelButtonTitle:cancelTitle
                                               destructiveButtonTitle:okTitle
                                                    otherButtonTitles:nil];
    [actionSheet setTag:2];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    
    // Show from our table view (pops up in the middle of the table).
    [actionSheet showInView:self.view];
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
//                [self.DAO DeleteLocalById:];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self.tableView setEditing:NO animated:YES];
            [self updateButtonsToMatchTableState];
        }
    }
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            NSLog(@"upload");
            [self updateButtonsToMatchTableState];
        }
    }

}



#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [self updateButtonsToMatchTableState];
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
    
    return cell;
}

#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState
{
    if (self.tableView.editing)
    {
        // Show the option to cancel the edit.
        self.navigationItem.rightBarButtonItem = self.cancelButton;
        
        [self updateDeleteButtonTitle];
        
        // Show the delete button.
        self.navigationItem.leftBarButtonItem = self.deleteButton;
    }
    else
    {
        // Not in editing mode.
        self.navigationItem.leftBarButtonItem = self.uploadButton;
        // Show the edit button, but disable the edit button if there's nothing to edit.

        if (self.dataArray.count > 0)
        {
            self.editButton.enabled = YES;
        }
        else
        {
            self.editButton.enabled = NO;
        }
        
        self.navigationItem.rightBarButtonItem = self.editButton;
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
