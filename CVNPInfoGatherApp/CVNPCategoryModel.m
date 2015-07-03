//
//  CVNPCategoryModel.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/1/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#define kCat_ID @"id"
#define kCat_Name @"name"
#define kCat_Description @"description"
#define kCat_Parent_ID @"parentID"

#import "CVNPCategoryModel.h"
#import "CVNPAPIClient.h"
@interface CVNPCategoryModel ()

@end

@implementation CVNPCategoryModel
@synthesize Cat_ID, Cat_Name, Cat_Description, Cat_Parent_ID;

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        Cat_ID = [NSString stringWithString:attributes[kCat_ID]];
        
        Cat_Name = [NSString stringWithString:![attributes[kCat_Name] isEqual:[NSNull null]] ? attributes[kCat_Name] : @"" ];
        Cat_Description = [NSString stringWithString: ![attributes[kCat_Description] isEqual:[NSNull null]] ? attributes[kCat_Description] : @"" ];
        Cat_Parent_ID = [NSString stringWithString:![attributes[kCat_Parent_ID] isEqual:[NSNull null]] ? attributes[kCat_Parent_ID] : @"0"];
        return self;
    }
    return nil;
}

+ (NSURLSessionDataTask *)PullCategoriesFromRemote:(void(^)(NSArray *AllCategories, NSError *error))block
{
    CVNPAPIClient *api = [CVNPAPIClient sharedClient];
    api.responseSerializer.acceptableContentTypes = [api.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *str = [NSString stringWithFormat:@"%@", @"loadtree.php"];
    return [api GET:str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *CategoriesFromResponse = [responseObject valueForKey:@"data"];
        NSMutableArray *CategoriesMutableArray = [NSMutableArray arrayWithCapacity:[CategoriesFromResponse count]];
        for (NSDictionary *CateDict in CategoriesFromResponse) {
            CVNPCategoryModel *Cate = [[CVNPCategoryModel alloc] initWithAttributes:CateDict];
            [CategoriesMutableArray addObject:Cate];
        }
        if (block) {
            block([NSArray arrayWithArray:CategoriesMutableArray],nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
