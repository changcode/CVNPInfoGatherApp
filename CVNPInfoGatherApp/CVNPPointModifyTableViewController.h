//
//  CVNPPointModifyTableViewController.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/16/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "CVNPPointsModel.h"

@interface CVNPPointModifyTableViewController : UITableViewController <RETableViewManagerDelegate>

@property (strong, readonly, nonatomic) RETableViewManager *manager;

@property (strong, readonly, nonatomic) RETableViewSection *gisInfoSection;
@property (strong, readonly, nonatomic) RETableViewSection *userInfoSection;
@property (strong, readonly, nonatomic) RETableViewSection *retainSection;
@property (strong, readonly, nonatomic) RETableViewSection *buttonSection;

@property (strong, nonatomic) CVNPPointsModel *currentPoint;

@end
