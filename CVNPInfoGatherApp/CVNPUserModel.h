//
//  CVNPUserModel.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/10/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CVNPUserModel : NSObject

@property (strong, nonatomic) NSString *User_ID;
@property (strong, nonatomic) NSString *User_Name;
@property (strong, nonatomic) NSString *User_Email;
@property (assign, nonatomic) BOOL *Logined;

- (id)initWithUser_ID:(NSString *)userID;

@end
