//
//  PointDetailViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPPointDetailViewController.h"

@interface CVNPPointDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CVNPPointDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView.contentSize = self.view.bounds.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
