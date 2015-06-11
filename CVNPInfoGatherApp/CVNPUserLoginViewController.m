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
    BFPaperButton *loginButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0, 0, 135, 83) raised:YES];
    [loginButton setBackgroundColor:[UIColor paperColorOrange]];
    loginButton.titleLabel.numberOfLines = 0;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [loginButton addTarget:self action:@selector(LoginbuttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.LoginButtonView addSubview:loginButton];
    
    BFPaperButton *ViewLocalPoints = [[BFPaperButton alloc] initWithFrame:CGRectMake(0, 0, 135, 83) raised:YES];
    [ViewLocalPoints setBackgroundColor:[UIColor paperColorOrange]];
    ViewLocalPoints.titleLabel.numberOfLines = 0;
    ViewLocalPoints.titleLabel.font = [UIFont systemFontOfSize:10.f];
    [ViewLocalPoints setTitle:@"Points In Local" forState:UIControlStateNormal];
    [ViewLocalPoints setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [ViewLocalPoints addTarget:self action:@selector(PointsListbuttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.anotherButtonView addSubview:ViewLocalPoints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)LoginbuttonWasPressed:(id)sender
{
    NSLog(@"%@ was pressed!", ((UIButton *)sender).titleLabel.text);
}

- (void)PointsListbuttonWasPressed:(id)sender
{
    [self performSegueWithIdentifier:@"GoCVNPPointsTableViewContrller" sender:nil];
}
@end
