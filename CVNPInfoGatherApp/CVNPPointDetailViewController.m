//
//  PointDetailViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPPointDetailViewController.h"

@interface CVNPPointDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latiudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;



@end

@implementation CVNPPointDetailViewController

@synthesize currPoint;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@:%@", [currPoint Longitude], [currPoint Latitude]);
}

- (void)viewWillAppear:(BOOL)animated
{
    _longitudeLabel.text = currPoint.Longitude;
    _latiudeLabel.text = currPoint.Latitude;
    _createTimeLabel.text = currPoint.CreateDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelItemButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addItemButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
