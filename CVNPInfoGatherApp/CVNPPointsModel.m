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
@synthesize Longitude, Latitude, Title, Description, User_ID, Server_ID, CreateDate, isUpdated, isCenter;

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
    CreateDate = attributes[@"Createdate"];
    return self;
}

+ (NSURLSessionDataTask *)User:(NSString *)user_id withRemotePointsWithBlock:(void(^)(NSArray *points, NSError *error))block{
    CVNPAPIClient *api = [CVNPAPIClient sharedClient];
    api.responseSerializer.acceptableContentTypes = [api.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *str = [NSString stringWithFormat:@"%@%@", @"load_location.php?userid=", user_id];
    return [api GET:str parameters:nil success:^(NSURLSessionDataTask *__unused task, id responseObject) {
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

+ (NSURLSessionDataTask *)UserUpload:(NSString *)user_id Points:(CVNPPointsModel *)Points withRemotePointsWithBlock:(void(^)(NSString *pointID, NSError *error))block{
    CVNPAPIClient *api = [CVNPAPIClient sharedClient];
    api.responseSerializer.acceptableContentTypes = [api.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *uploadStr = [NSString stringWithFormat:@"add_location.php?title=%@&longitude=%@&latitude=%@&description=%@&userid=%@", Points.Title, Points.Longitude, Points.Latitude, Points.Description, user_id];
    return [api GET:uploadStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *pointsFromResponse = [responseObject valueForKey:@"id"];
        if (block) {
            NSLog(@"%@",pointsFromResponse);
            block(pointsFromResponse, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(@"-1", error);
        }
    }];
}

@end
