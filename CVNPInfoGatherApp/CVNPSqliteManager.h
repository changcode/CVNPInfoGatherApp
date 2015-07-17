//
//  CVNPSqliteManager.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVNPPointsModel.h"
#import "CVNPCategoryModel.h"

@interface CVNPSqliteManager : NSObject


+ (CVNPSqliteManager *)sharedCVNPSqliteManager;

#pragma mark - Points Methods
- (NSArray *)QueryAllLocal;
- (BOOL)InsertLocal: (CVNPPointsModel *)Point;
- (BOOL)DeleteLocalById: (int)ID;
- (BOOL)DeleteLocalByIds:(NSArray *)IDs;
- (BOOL)DeleteAllLocations;
- (BOOL)UpdateLocalById: (int)ID newPoint:(CVNPPointsModel *)Point;
- (BOOL)SyncFromRemote:(CVNPPointsModel *)Point;

#pragma mark - Categroy Methods
- (BOOL)JudgeCategriesNeedsUpdate;
- (BOOL)InsterALLCategoriesFrom:(NSArray *)Categories;
- (BOOL)DeleteALLCategories;
- (CVNPCategoryModel *)QueryCategoryInfoById:(NSString *)ID;
- (NSArray *)QueryAllCategories;
- (NSArray *)QueryChildCategoriesByCate:(CVNPCategoryModel *)cate;
- (BOOL)JudgeCategriesHasChildren:(CVNPCategoryModel *)cate;

#pragma mark - Photos Methods
- (BOOL)InsertPhotoRecordswithFileName:(NSString *)PhotoFileName andUser_ID:(NSString *)User_ID;
- (NSNumber *)QueryIdByPhotoFileName:(NSString *)PhotoFileName;
- (NSString *)QueryFileNameByPhotoID:(NSNumber *)Photo_ID;
- (BOOL)DeletePhotoByFileName:(NSString *)PhotoFileName;
@end
