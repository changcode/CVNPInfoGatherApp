//
//  CVNPPointsModel.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPPointsModel.h"

@interface CVNPPointsModel()

@end

@implementation CVNPPointsModel
@synthesize Longitude, Latitude, Title, Description, User_ID, Server_ID, CreateDate;

- (id)initWithLongitude:(NSString *)longitude Latitdue:(NSString *)latitude Title:(NSString *)title Description:(NSString *)description User_ID:(NSString *)user_ID Server_ID:(NSString *)server_ID CreateDate:(NSString *)createDate
{
    if (self = [super init]) {
        Longitude = longitude ? longitude : @"";
        Latitude = latitude ? latitude : @"";
        Title = title ? title : @"";
        Description = description ? description : @"";
        User_ID = user_ID ? user_ID : @"";
        Server_ID = server_ID ? server_ID : @"";
        CreateDate = createDate ? createDate : @"";
    }
    return self;
}

@end
