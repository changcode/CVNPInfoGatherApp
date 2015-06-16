//
//  CVNPPointsModel.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPPointsModel.h"
#import "CVNPAPIClient.h"

@interface CVNPPointsModel()

@end

@implementation CVNPPointsModel
@synthesize Longitude, Latitude, Title, Description, User_ID, Server_ID, CreateDate, isCenter;

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
        isCenter = FALSE;
    }
    return self;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    Longitude = attributes[@"Longitude"];
    Latitude = attributes[@"Latitude"];
    Title = attributes[@"Title"];
    Description = attributes[@"Description"];
    User_ID = attributes[@"User_ID"];
    Server_ID = attributes[@"ID"];
    return self;
}

+ (NSURLSessionDataTask *)allRemotePointsWithBlock:(void(^)(NSArray *points, NSError *error))block {
    CVNPAPIClient *api = [CVNPAPIClient sharedClient];
    api.responseSerializer.acceptableContentTypes = [api.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    return [api GET:@"load_location.php?userid=18" parameters:nil success:^(NSURLSessionDataTask *__unused task, id responseObject) {
        NSArray *pointsFromResponse = [responseObject valueForKey:@"data"];
        NSMutableArray *mutablePoints = [NSMutableArray arrayWithCapacity:[pointsFromResponse count]];
        for (NSDictionary *PointDict in pointsFromResponse) {
            CVNPPointsModel *Point = [[CVNPPointsModel alloc] initWithAttributes:PointDict];
            [mutablePoints addObject:Point];
        }
        if (block) {
            block([NSArray arrayWithArray:mutablePoints], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
