//
//  CVNPPointPresentImageCell.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 7/13/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPPointPresentImageCell.h"

@interface CVNPPointPresentImageCell ()

@property (strong, readwrite, nonatomic) UIImageView *pictureView;

@end
@implementation CVNPPointPresentImageCell

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return 306;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    self.pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0, 306, 306)];
    self.pictureView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:self.pictureView];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    [self.pictureView setImage:[UIImage imageWithContentsOfFile:self.item.imagePath]];
}

@end
