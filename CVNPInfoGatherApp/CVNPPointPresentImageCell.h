//
//  CVNPPointPresentImageCell.h
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/13/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "RETableViewCell.h"
#import "CVNPPointPresentImageItem.h"

@interface CVNPPointPresentImageCell : RETableViewCell

@property (strong, readonly, nonatomic) UIImageView *pictureView;
@property (strong, nonatomic) CVNPPointPresentImageItem *item;
@end
