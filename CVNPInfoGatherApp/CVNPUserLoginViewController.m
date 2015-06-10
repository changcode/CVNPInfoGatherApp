//
//  CVNPUserLoginViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/10/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPUserLoginViewController.h"
#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"


@interface CVNPUserLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *LoginButtonView;
@property (weak, nonatomic) IBOutlet UIView *anotherButtonView;

@end

@implementation CVNPUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BFPaperButton *bfRaisedSmartSmall = [[BFPaperButton alloc] initWithFrame:CGRectMake(0, 0, 135, 83) raised:YES];
    [bfRaisedSmartSmall setBackgroundColor:[UIColor paperColorOrange]];
    bfRaisedSmartSmall.titleLabel.numberOfLines = 0;
    bfRaisedSmartSmall.titleLabel.font = [UIFont systemFontOfSize:10.f];
    [bfRaisedSmartSmall setTitle:@"Login" forState:UIControlStateNormal];
    [bfRaisedSmartSmall setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [bfRaisedSmartSmall addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.LoginButtonView addSubview:bfRaisedSmartSmall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buttonWasPressed:(id)sender
{
    NSLog(@"%@ was pressed!", ((UIButton *)sender).titleLabel.text);
}
@end
