//
//  CVNPCategoryModel.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/1/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CVNPCategoryModel : NSObject

@property (strong, nonatomic) NSString *Cat_ID;
@property (strong, nonatomic) NSString *Cat_Name;
@property (strong, nonatomic) NSString *Cat_Description;
@property (strong, nonatomic) NSString *Cat_Parent_ID;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)PullCategoriesFromRemote:(void(^)(NSArray *AllCategories, NSError *error))block;

@end
