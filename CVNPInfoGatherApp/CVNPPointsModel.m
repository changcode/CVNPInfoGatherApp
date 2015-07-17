//
//  CVNPPointsModel.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//
#import "CVNPPointsModel.h"
#import "CVNPAPIClient.h"
#import "CVNPSqliteManager.h"

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
    isUpdated = 1;
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

+ (AFHTTPRequestOperation *)UserUpload:(NSString *)user_id Points:(CVNPPointsModel *)Points withRemotePointsWithBlock:(void(^)(NSString *pointID, NSError *error))block{
//    CVNPAPIClient *api = [CVNPAPIClient sharedClient];
//    api.responseSerializer.acceptableContentTypes = [api.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    NSString *uploadStr = @"add_location.php";
    CVNPSqliteManager *DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    
    
    NSDictionary *parameters = @{@"title" : Points.Title,
                                 @"longitude" : Points.Longitude,
                                 @"latitude" : Points.Latitude,
                                 @"description" : Points.Description,
                                 @"userid" : user_id,
                                 @"categories_id" : Points.Category
                                 };
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSError *error = [[NSError alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request;
    if ([Points.Photo_ID intValue] != -1) {
        NSString *fileName = [DAO QueryFileNameByPhotoID:Points.Photo_ID];
        NSURL *filePath = [NSURL fileURLWithPath:[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"CVNPSavedIMG"]stringByAppendingPathComponent:fileName]];
        
        request = [serializer multipartFormRequestWithMethod:@"POST" URLString:@"http://parkapps.kent.edu/demo/add_location.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"file" error:nil];
        } error:&error];
    } else {
        request = [serializer requestWithMethod:@"POST" URLString:@"http://parkapps.kent.edu/demo/add_location.php" parameters:parameters error:&error];
    }
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            NSNumber *returnServer_ID = [responseObject valueForKey:@"id"];
            NSLog(@"%@", responseObject);
            block([returnServer_ID stringValue], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(@"-1", error);
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    return operation;
//        return [api POST:uploadStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            [formData appendPartWithFileURL:filePath name:@"file" error:nil];
//        } success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSNumber *returnServer_ID = [responseObject valueForKey:@"id"];
//            if (block) {
//                NSLog(@"%@",returnServer_ID);
//                block([returnServer_ID stringValue], nil);
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            if (block) {
//                block(@"-1", error);
//            }
//        }];
    
    
    
//    return [api POST:uploadStr parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSNumber *returnServer_ID = [responseObject valueForKey:@"id"];
//        if (block) {
//            NSLog(@"%@",returnServer_ID);
//            block([returnServer_ID stringValue], nil);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (block) {
//            block(@"-1", error);
//        }
//    }];
}

@end
