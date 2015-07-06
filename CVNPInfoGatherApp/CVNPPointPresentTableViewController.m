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
#import "CVNPCategoryTableViewController.h"

@interface CVNPPointPresentTableViewController () <CVNPCategoryTableViewControllerDelegate>

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *gisInfoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *userInfoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *retainSection;

@property (strong, readwrite, nonatomic) RETextItem *longitudeItem;
@property (strong, readwrite, nonatomic) RETextItem *latitudeItem;
@property (strong, readwrite, nonatomic) RETextItem *createTimeItem;

@property (strong, readwrite, nonatomic) RETextItem *titleItem;
@property (strong, readwrite, nonatomic) RELongTextItem *descriptionItem;
@property (strong, readwrite, nonatomic) REPickerItem *categoryPickerItem;
@property (strong, readwrite, nonatomic) RETableViewItem *categoryDetailItem;

@property (strong, nonatomic) CVNPSqliteManager *DAO;
@property (strong, nonatomic) CVNPCategoryModel *selectedCategory;
@end

@implementation CVNPPointPresentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Point Infomation";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    
    [self updateLocalCategory];
    
    self.userInfoSection = [self addUsernfoControls];
    self.gisInfoSection = [self addGISControls];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (RETableViewSection *)addUsernfoControls
{
    __typeof (&*self) __weak weakSelf = self;
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"User Input Informations"];
    [self.manager addSection:section];
    
    self.titleItem = [RETextItem itemWithTitle:@"Title" value:nil placeholder:@"Title"];
    
    self.descriptionItem = [RELongTextItem itemWithValue:nil placeholder:@"Description"];
    self.descriptionItem.cellHeight = 100;
    
    _selectedCategory = [[CVNPCategoryModel alloc] init];
    [_selectedCategory setCat_ID:@"0"];
    
    NSArray *categoriesObjectInPicker = [NSArray arrayWithArray:[_DAO QueryChildCategoriesByCate:_selectedCategory]];
    NSMutableArray * cateName = [[NSMutableArray alloc] init];
    for (CVNPCategoryModel *cate in categoriesObjectInPicker) {
        [cateName addObject:[cate Cat_Name]];
    }

    self.categoryPickerItem = [REPickerItem itemWithTitle:@"Category Picker" value:@[[cateName objectAtIndex:0]] placeholder:nil options:@[cateName]];
    self.categoryPickerItem.onChange = ^(REPickerItem *item) {
        for (CVNPCategoryModel *cate in categoriesObjectInPicker) {
            if ([item.value[0] isEqualToString:[cate Cat_Name]]) {
                weakSelf.selectedCategory = cate;
            }
        }
    };
    self.selectedCategory = categoriesObjectInPicker[0];
    self.categoryPickerItem.inlinePicker = YES;
    
    self.categoryDetailItem = [RETableViewItem itemWithTitle:@"Category Detail" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        CVNPCategoryTableViewController *controller = [[CVNPCategoryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        controller.delegate = weakSelf;
        controller.level = 0;
        controller.parentCategory = weakSelf.selectedCategory;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    [section addItem:self.titleItem];
    [section addItem:self.descriptionItem];
    [section addItem:self.categoryPickerItem];
    [section addItem:self.categoryDetailItem];

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

- (void)getSelectCategory:(NSString *)text
{
    self.categoryDetailItem.detailLabelText = text;
    self.categoryDetailItem.style = UITableViewCellStyleValue1;
    [self.categoryDetailItem reloadRowWithAnimation:UITableViewRowAnimationNone];
    NSLog(@"!!!%@",text);
}

@end
