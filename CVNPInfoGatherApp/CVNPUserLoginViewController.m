//
//  CVNPUserLoginViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/10/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPSqliteManager.h"
#import "CVNPPointsModel.h"
#import "CVNPAPIClient.h"

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
@property (weak, nonatomic) IBOutlet UIView *uploadButtonView;

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
    [ViewLocalPoints setTitle:@"Points List" forState:UIControlStateNormal];
    [ViewLocalPoints setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [ViewLocalPoints addTarget:self action:@selector(PointsListbuttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.anotherButtonView addSubview:ViewLocalPoints];
    
    BFPaperButton *uploadButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0, 0, 86, 86) raised:NO];
    [uploadButton setTitle:@"Upload" forState:UIControlStateNormal];
    [uploadButton setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [uploadButton setTitleColor:[UIColor paperColorGray900] forState:UIControlStateNormal];
    [uploadButton setTitleColor:[UIColor paperColorGray900] forState:UIControlStateHighlighted];
    [uploadButton addTarget:self action:@selector(UploadButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    uploadButton.cornerRadius = uploadButton.frame.size.width / 2;
    uploadButton.tapCircleDiameter = 53;
    uploadButton.tapCircleColor = [UIColor colorWithRed:0.3 green:0 blue:1 alpha:0.6];  // Setting this color overrides "Smart Color".
    uploadButton.backgroundFadeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.3f]; // Setting this color overrides "Smart Color".
    [self.uploadButtonView addSubview:uploadButton];
    
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
        
        [Config saveOwnAccount:_usernameTextfield.text andPassword:_passwordTextfiled.text];
        [Config saveOwnID:result[@"userid"] userName:_usernameTextfield.text score:0 favoriteCount:0 fansCount:0 andFollowerCount:0];
        
        [self performSegueWithIdentifier:@"GoCVNPPointsTableViewContrller" sender:nil];
        [_HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _HUD.labelText = [NSString stringWithFormat:@"Networking error:%@", error.localizedDescription];
        [_HUD hide:YES afterDelay:1];
    }];
}

- (void)PointsListbuttonWasPressed:(id)sender
{
    [self performSegueWithIdentifier:@"GoCVNPPointsTableViewContrller" sender:nil];
}

- (void)UploadButtonWasPressed:(id)sender
{
    [self performSegueWithIdentifier:@"GoCVNPUploadTableViewController" sender:nil];
}

- (IBAction)startNetWork:(id)sender {
    UIApplication *app = [UIApplication sharedApplication];
    if (app.isNetworkActivityIndicatorVisible) {
        app.networkActivityIndicatorVisible = NO;
    }else {
        app.networkActivityIndicatorVisible = YES;
    }
}
- (IBAction)testUpload:(id)sender {
    NSArray *localUploadingData = [[CVNPSqliteManager sharedCVNPSqliteManager] QueryAllLocal];
    __block NSString *serverID;
    [CVNPPointsModel UserUpload:[Config getOwnID] Points:localUploadingData[0] withRemotePointsWithBlock:^(NSString *pointID, NSError *error) {
        if (!error) {
            serverID = pointID;
        }
    }];
}
@end
