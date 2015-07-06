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

- (NSArray *)QueryAllLocal;
- (BOOL)InsertLocal: (CVNPPointsModel *)Point;
- (BOOL)DeleteLocalById: (int)ID;
- (BOOL)DeleteLocalByIds:(NSArray *)IDs;
- (BOOL)UpdateLocalById: (int)ID newPoint:(CVNPPointsModel *)Point;
- (BOOL)SyncFromRemote:(CVNPPointsModel *)Point;

- (BOOL)InsterALLCategoriesFrom:(NSArray *)Categories;
- (BOOL)DeleteALLCategories;
- (NSArray *)QueryAllCategories;
- (NSArray *)QueryChildCategoriesByCate:(CVNPCategoryModel *)cate;
- (BOOL)JudgeCategriesHasChildren:(CVNPCategoryModel *)cate;
@end
