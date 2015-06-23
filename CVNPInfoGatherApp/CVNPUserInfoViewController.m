//
//  CVNPUserInfoViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/22/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "Config.h"

#import "CVNPUserInfoForm.h"
#import "CVNPUserInfoViewController.h"

@interface CVNPUserInfoViewController () <UIAlertViewDelegate>

@end

@implementation CVNPUserInfoViewController
- (void)awakeFromNib
{
    self.formController.form = [[CVNPUserInfoForm alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)mapAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logoutAction
{
    if ([Config isLogined]) {
        
        UIAlertView *confirLogout = [[UIAlertView alloc] initWithTitle:@"Confirm Logout" message:@"Confirm Logout" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [confirLogout show];
    }
    else{
        [self performSegueWithIdentifier:@"GoCVNPTutorialViewController" sender:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [Config removeOwnId];
        [self performSegueWithIdentifier:@"GoCVNPTutorialViewController" sender:nil];
//        NSLog(@"Confirm");
    }
    else
    {
//        NSLog(@"cancel");       
    }
}
@end
