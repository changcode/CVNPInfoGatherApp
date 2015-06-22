//
//  CVNPLoginRegistrationFormViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/22/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//
#import "Config.h"
#import "CVNPLoginRegistrationFormViewController.h"
#import "CVNPLoginRegstrationForm.h"
#import "CVNPRegistrationForm.h"

#import "AFNetworking.h"
#import "MBProGressHUD.h"

static NSString * const BaseURLString = @"http://parkapps.kent.edu/demo/";

@interface CVNPLoginRegistrationFormViewController ()

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation CVNPLoginRegistrationFormViewController
- (void)awakeFromNib
{
    self.formController.form = [[CVNPLoginRegstrationForm alloc] init];
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
}


- (void)submitLoginForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    CVNPLoginForm *loginForm = cell.field.form;
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:_HUD];
    _HUD.labelText = @"Loging...";
    _HUD.dimBackground = YES;
    _HUD.userInteractionEnabled = NO;
    [_HUD show:YES];
    
    NSString *URLstring = [NSString stringWithFormat:@"%@login_location.php?username=%@&password=%@",BaseURLString, loginForm.username, loginForm.password];
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
        
        [Config saveOwnAccount:loginForm.username andPassword:loginForm.password];
        [Config saveOwnID:result[@"userid"] userName:loginForm.username score:0 favoriteCount:0 fansCount:0 andFollowerCount:0];
        
        [self performSegueWithIdentifier:@"GoCVNPViewController" sender:nil];
        [_HUD hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _HUD.labelText = [NSString stringWithFormat:@"Networking error:%@", error.localizedDescription];
        [_HUD hide:YES afterDelay:1];
    }];
}

@end
