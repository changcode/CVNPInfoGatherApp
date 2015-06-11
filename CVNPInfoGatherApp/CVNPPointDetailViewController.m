//
//  PointDetailViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPPointDetailViewController.h"
#import "CVNPSqliteManager.h"

#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"

@interface CVNPPointDetailViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latiudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *localIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *modifyButton;

@property (weak, nonatomic) IBOutlet UIView *delButtonView;
@property (strong, nonatomic) CVNPSqliteManager *DAO;

@end

@implementation CVNPPointDetailViewController

@synthesize currPoint;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DAO = [CVNPSqliteManager sharedCVNPSqliteManager];
    _titleTextField.delegate = self;
    _descriptionTextView.delegate = self;
    
    BFPaperButton *delButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0, 0, 280, 43) raised:YES];
    delButton.usesSmartColor = NO;
    [delButton setBackgroundColor:[UIColor paperColorRed]];
    [delButton setTitle:@"Delete" forState:UIControlStateNormal];
    [delButton setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [delButton addTarget:self action:@selector(delButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.delButtonView addSubview:delButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    _titleTextField.text = currPoint.Title;
    _descriptionTextView.text = currPoint.Title;
    _longitudeLabel.text = currPoint.Longitude;
    _latiudeLabel.text = currPoint.Latitude;
    _createTimeLabel.text = currPoint.CreateDate;
    _localIDLabel.text = currPoint.Local_ID;
    [self updateButtonsToMatchTableState];
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

- (IBAction)modifyItemButtonPressed:(id)sender {
    currPoint.Title = _titleTextField.text;
    currPoint.Description = _descriptionTextView.text;
    [_DAO UpdateLocalById:[currPoint.Local_ID intValue] newPoint:currPoint];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)delButtonPressed:(id)sender {
    [_DAO DeleteLocalById:[currPoint.Local_ID intValue]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissKeybaord:(id)sender {
    [_titleTextField resignFirstResponder];
    [_descriptionTextView resignFirstResponder];
}

- (void)updateButtonsToMatchTableState
{
    if (currPoint.isCenter)
    {
        self.delButtonView.hidden = YES;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = _modifyButton;

    }
}

@end
