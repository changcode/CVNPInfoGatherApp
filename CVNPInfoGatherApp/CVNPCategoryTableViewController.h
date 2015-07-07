//
//  CVNPCategoryTableViewController.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/2/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "CVNPSqliteManager.h"
@protocol CVNPCategoryTableViewControllerDelegate <NSObject>
@optional
- (void)getSelectCategory:(CVNPCategoryModel *)choosen;
@end


@interface CVNPCategoryTableViewController : UITableViewController <RETableViewManagerDelegate>

@property (assign, nonatomic) int level;
@property (strong, nonatomic) CVNPCategoryModel *parentCategory;
@property (weak, nonatomic)id<CVNPCategoryTableViewControllerDelegate> delegate;

@end
