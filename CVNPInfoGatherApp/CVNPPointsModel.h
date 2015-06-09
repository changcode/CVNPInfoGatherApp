//
//  CVNPPointsModel.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CVNPPointsModel : NSObject

@property (strong, nonatomic) NSString *Longitude;
@property (strong, nonatomic) NSString *Latitude;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSString *CreateDate;

@property (strong, nonatomic) NSString *User_ID;
@property (strong, nonatomic) NSString *Server_ID;
@property (strong, nonatomic) NSString *Local_ID;


- (id)initWithLongitude:(NSString *)longitude Latitdue:(NSString *)latitude Title:(NSString *)title Description:(NSString *)description User_ID:(NSString *)user_ID Server_ID:(NSString *)server_ID CreateDate:(NSString *)createDate;

@end