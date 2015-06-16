//
//  CVNPUserLoginViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/10/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPUserLoginViewController.h"
#import "CVNPUserModel.h"
#import "Config.h"

#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"
#import "AFNetworking.h"
#import "MBProGressHUD.h"

static NSString * const BaseURLString = @"http://parkapps.kent.edu/demo/";

@interface CVNPUserLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfiled;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UIView *LoginButtonView;
@property (weak, nonatomic) IBOutlet UIView *anotherButtonView;

@property (strong, nonatomic) MBProgressHUD *HUD;

@property (strong) NSDictionary *userInfo;
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
    
    NSArray *accountAndPassword = [Config getOwnAccountAndPassword];
    _usernameTextfield.text = accountAndPassword? accountAndPassword[0] : @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)LoginbuttonWasPressed:(id)sender
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.labelText = @"Loging...";
    _HUD.dimBackground = YES;
    _HUD.userInteractionEnabled = NO;
    [_HUD show:YES];
    
    NSString *URLstring = [NSString stringWithFormat:@"%@login_location.php?username=%@&password=%@",BaseURLString, _usernameTextfield.text, _passwordTextfiled.text];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:URLstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"result"] isEqualToString:@"false"]) {
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelText = @"Username/password unmatch!";
            [_HUD hide:YES afterDelay:1];
            return;
        }
        
//        CVNPUserModel *user = [[CVNPUserModel alloc] initWithDictionary:responseObject];
        [Config saveOwnAccount:_usernameTextfield.text andPassword:_passwordTextfiled.text];
        
        [self performSegueWithIdentifier:@"GoCVNPPointsTableViewContrller" sender:nil];
        [_HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _HUD.labelText = [NSString stringWithFormat:@"Networking error:%@", error.localizedDescription];
        [_HUD hide:YES afterDelay:1];
    }];
}

- (IBAction)getPoints:(id)sender {
    NSString *URLstring = [NSString stringWithFormat:@"%@load_location.php?userid=%@",BaseURLString, @"13"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:URLstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"result"] isEqualToString:@"false"]) {
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelText = @"Unkonwn Error";
            [_HUD hide:YES afterDelay:1];
            return;
        }
        [_HUD hide:YES];
        NSLog(@"%@", result[@"data"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _HUD.labelText = [NSString stringWithFormat:@"Networking error:%@", error.localizedDescription];
        [_HUD hide:YES afterDelay:1];
    }];
    
}


- (void)PointsListbuttonWasPressed:(id)sender
{
    [self performSegueWithIdentifier:@"GoCVNPPointsTableViewContrller" sender:nil];
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
