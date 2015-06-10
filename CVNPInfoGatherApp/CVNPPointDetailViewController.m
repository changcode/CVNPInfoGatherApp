//
//  PointDetailViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPPointDetailViewController.h"
#import "CVNPSqliteManager.h"

@interface CVNPPointDetailViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latiudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *localIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;


@property (strong, nonatomic) CVNPSqliteManager *DAO;

@end

@implementation CVNPPointDetailViewController

@synthesize currPoint;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    _titleTextField.delegate = self;
    _descriptionTextView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    _longitudeLabel.text = currPoint.Longitude;
    _latiudeLabel.text = currPoint.Latitude;
    _createTimeLabel.text = currPoint.CreateDate;
    _localIDLabel.text = currPoint.Local_ID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_descriptionTextView becomeFirstResponder];
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)cancelItemButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addItemButtonPressed:(id)sender {
    [currPoint setTitle:_titleTextField.text];
    [currPoint setDescription:_titleTextField.text];
    [currPoint setUser_ID:@"-1"];
    
    [_DAO InsertLocal:currPoint];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)dismissKeybaord:(id)sender {
    [_titleTextField resignFirstResponder];
    [_descriptionTextView resignFirstResponder];
}

@end
