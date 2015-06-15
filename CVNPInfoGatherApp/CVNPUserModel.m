//
//  CVNPUserModel.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/10/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPUserModel.h"

static NSString * const kID = @"uid";
static NSString * const kUserID = @"userid";
static NSString * const kUserEmail = @"email";
static NSString * const kLocation = @"location";
static NSString * const kFrom = @"from";
static NSString * const kName = @"name";
static NSString * const kFollowers = @"followers";
static NSString * const kFans = @"fans";
static NSString * const kScore = @"score";
static NSString * const kPortrait = @"portrait";
static NSString * const kFavoriteCount = @"favoritecount";
static NSString * const kExpertise = @"expertise";


@implementation CVNPUserModel

- (instancetype)initWithDictionary: (NSDictionary *)dict
{
    if (self = [super init]) {
        _User_ID = dict[kUserID];
        _User_Email = dict[kUserEmail];
    }
    return self;
}

@end
