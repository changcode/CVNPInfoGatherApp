//
//  CVNPUserLoginViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/10/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPUserLoginViewController.h"
#import "CVNPNetworkingManager.h"

#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"


@interface CVNPUserLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfiled;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UIView *LoginButtonView;
@property (weak, nonatomic) IBOutlet UIView *anotherButtonView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
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
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 200, 30, 30)];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
//    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
//    [operationQueue setMaxConcurrentOperationCount:1];
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(runIndicator) object:nil];
//    [operationQueue addOperation:operation];
    CVNPNetworkingManager *cvnpnetworking = [CVNPNetworkingManager sharedCVNPNetworkingManager];
    NSDictionary *test = [cvnpnetworking userLoginwithUsername:_usernameTextfield.text andPassword:_passwordTextfiled.text];
//    NSDictionary *test = [cvnpnetworking ManageruserLoginwithUsername:_usernameTextfield.text andPassword:_passwordTextfiled.text];
//    [cvnpnetworking userAllPoints:test[@"userid"]];
    NSLog(@"%@", test);
}

- (void)PointsListbuttonWasPressed:(id)sender
{
    [self performSegueWithIdentifier:@"GoCVNPPointsTableViewContrller" sender:nil];
}

-(void)runIndicator
{
    //开启线程并睡眠三秒钟
    [NSThread sleepForTimeInterval:1];
    //停止UIActivityIndicatorView
    [self.activityIndicatorView stopAnimating];
}

- (IBAction)startNetWork:(id)sender {
    UIApplication *app = [UIApplication sharedApplication];
    if (app.isNetworkActivityIndicatorVisible) {
        app.networkActivityIndicatorVisible = NO;
    }else {
        app.networkActivityIndicatorVisible = YES;
    }
}
@end
