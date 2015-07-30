//
//  CVNPSettingTableViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/30/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPSettingTableViewController.h"

@interface CVNPSettingTableViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (strong, readwrite, nonatomic) RETableViewSection *appInfoSection;

@property (strong, readwrite, nonatomic) RETextItem *versionItem;
@property (strong, readwrite, nonatomic) RETextItem *buildItem;

@end

@implementation CVNPSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    
    self.appInfoSection = [self addAppInfoSection];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RETableViewForm

- (RETableViewSection *)addAppInfoSection
{
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"App Version Info"];
    [self.manager addSection:section];
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    self.versionItem = [RETextItem itemWithTitle:@"Version" value:appVersionString];
    self.buildItem = [RETextItem itemWithTitle:@"Build" value:appBuildString];
    
    self.versionItem.enabled = NO;
    self.buildItem.enabled = NO;
    
    [section addItem:self.versionItem];
    [section addItem:self.buildItem];
    
    return section;
}

@end
