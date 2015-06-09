//
//  CVNPSqliteManager.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVNPPointsModel.h"

@interface CVNPSqliteManager : NSObject


+ (CVNPSqliteManager *)sharedCVNPSqliteManager;

- (NSArray *)QueryAllLocal;
- (BOOL)InsertLocal: (CVNPPointsModel *)Point;
- (BOOL)DeleteLocalById: (int)ID;
- (BOOL)UpdateLocalById: (int)ID newPoint:(CVNPPointsModel *)Point;

@end