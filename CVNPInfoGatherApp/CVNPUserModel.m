//
//  CVNPUserModel.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/10/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPUserModel.h"

@implementation CVNPUserModel

@synthesize User_Name, User_Email, User_ID;


- (id)initWithUser_ID:(NSString *)userID
{
    if (self = [super init]) {
        self.User_ID = userID;
        self.Logined = false;
    }
    return self;
}

@end
