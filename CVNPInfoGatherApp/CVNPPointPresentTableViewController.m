//
//  CVNPPointPresentTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/2/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPPointPresentTableViewController.h"
#import "CVNPCategoryModel.h"
#import "CVNPSqliteManager.h"

@interface CVNPPointPresentTableViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *gisInfoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *userInfoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *retainSection;


@property (strong, readwrite, nonatomic) RETextItem *longitudeItem;
@property (strong, readwrite, nonatomic) RETextItem *latitudeItem;
@property (strong, readwrite, nonatomic) RETextItem *createTimeItem;

@property (strong, readwrite, nonatomic) RETextItem *titleItem;
@property (strong, readwrite, nonatomic) RELongTextItem *descriptionItem;
@property (strong, readwrite, nonatomic) REPickerItem *CategoryPickerItem;

@property (strong, nonatomic) CVNPSqliteManager *DAO;

@end

@implementation CVNPPointPresentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Point Infomation";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    
    self.userInfoSection = [self addUsernfoControls];
    self.gisInfoSection = [self addGISControls];
    
    [self updateLocalCategory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (RETableViewSection *)addUsernfoControls
{
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"User Input Informations"];
    [self.manager addSection:section];
    
    self.titleItem = [RETextItem itemWithTitle:@"Title" value:nil placeholder:@"Title"];
    
    self.descriptionItem = [RELongTextItem itemWithValue:nil placeholder:@"Description"];
    self.descriptionItem.cellHeight = 100;
    self.CategoryPickerItem = [REPickerItem itemWithTitle:@"Category Picker" value:@[@"Category"] placeholder:nil options:@[@[@"Category", @"Ecosystem", @"Geology", @"Hydrology", @"Structures", @"Flora(Plants)", @"Hazards & Warnings", @"Others"]]];
    self.CategoryPickerItem.onChange = ^(REPickerItem *item) {
        NSLog(@"Value: %@", item.value.description);
    };
    self.CategoryPickerItem.inlinePicker = YES;

    
    [section addItem:self.titleItem];
    [section addItem:self.descriptionItem];
    [section addItem:self.CategoryPickerItem];
    
    return section;
}

- (RETableViewSection *)addGISControls
{
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"GIS Informations"];
    [self.manager addSection:section];
    
    self.longitudeItem =  [RETextItem itemWithTitle:@"Longitutd" value:@"12.345678"];
    self.latitudeItem =  [RETextItem itemWithTitle:@"Latitude" value:@"12.345678"];
    self.createTimeItem = [RETextItem itemWithTitle:@"Created Time" value:@"2000/10/10 22:12PM"];
    
    self.longitudeItem.enabled = NO;
    self.latitudeItem.enabled = NO;
    self.createTimeItem.enabled = NO;
    
    [section addItem:self.longitudeItem];
    [section addItem:self.latitudeItem];
    [section addItem:self.createTimeItem];
    
    return section;
}

- (void)updateLocalCategory
{
    _DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    [CVNPCategoryModel PullCategoriesFromRemote:^(NSArray *AllCategories, NSError *error) {
        [_DAO DeleteALLCategories];
        [_DAO InsterALLCategoriesFrom:AllCategories];
    }];
}

@end
