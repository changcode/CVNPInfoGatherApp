//
//  CVNPNetworkingManager.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/11/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPNetworkingManager.h"
#import "AFNetworking.h"
@interface CVNPNetworkingManager ()

@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) NSArray *userPoints;
@end

@implementation CVNPNetworkingManager

static CVNPNetworkingManager *CVNPNetworkingSingle = nil;
static NSString * const BaseURLString = @"http://parkapps.kent.edu/demo/";


+ (CVNPNetworkingManager *)sharedCVNPNetworkingManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CVNPNetworkingSingle = [[self alloc] init];
    });
    return CVNPNetworkingSingle;
}

- (NSDictionary *)userLoginwithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSString *string = [NSString stringWithFormat:@"%@login_location.php?username=%@&password=%@",BaseURLString, username, password];

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"%@", responseObject);
//        self.userInfo= [[NSDictionary alloc] initWithDictionary:
//        (NSDictionary *)responseObject];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
    
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSLog(@"%@", string);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // Make sure to set the responseSerializer correctly
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        self.userInfo= [[NSDictionary alloc] initWithDictionary:
                        (NSDictionary *)responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
    return self.userInfo;
}

- (NSDictionary *)ManageruserLoginwithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSString *string = [NSString stringWithFormat:@"%@login_location.php?username=%@&password=%@",BaseURLString, username, password];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.userInfo= [[NSDictionary alloc] initWithDictionary:
        (NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    return self.userInfo;
}

- (NSArray *)userAllPoints:(NSString *)userid
{
    NSString *string = [NSString stringWithFormat:@"%@load_location.php?userid=%@", BaseURLString, userid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"%@", string);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        self.userInfo = (NSArray *)responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    return self.userInfo;
}

@end
