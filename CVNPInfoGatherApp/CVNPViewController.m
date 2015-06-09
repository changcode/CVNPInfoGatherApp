//
//  ViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPViewController.h"
#import "CVNPSqliteManager.h"
#import "BFPaperButton.h"

#define kRegularSourceID   @"changshu1991.kal6f5d3"
#define kTerrainSourceID   @"changshu1991.l2e7f119"
#define kSatelliteSourceID @"changshu1991.l2e7o1mb"

#define kAccessKey @"pk.eyJ1IjoianVzdGluIiwiYSI6IlpDbUJLSUEifQ.4mG8vhelFMju6HpIY-Hi5A"

@interface CVNPViewController ()

@property (strong, nonatomic) RMMapView *mapView;
@property (strong, nonatomic) RMMapboxSource *onlineTileSource;
@property (strong, nonatomic) RMMBTilesSource *offlineTileSource;
@property (assign, nonatomic) CLLocationCoordinate2D mapCenter;

@property (weak, nonatomic) IBOutlet UISegmentedControl *tileSourceSegmentSwith;
@property (weak, nonatomic) IBOutlet UIView *recordButtonView;

@end

@implementation CVNPViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RMConfiguration sharedInstance] setAccessToken:kAccessKey];
    _onlineTileSource = [[RMMapboxSource alloc] initWithMapID:kRegularSourceID];
    _offlineTileSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"1-16_jpg_tiles" ofType:@"mbtiles"];
    
    _mapCenter = CLLocationCoordinate2DMake(41.2854277, -81.5656396);
    _mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:_offlineTileSource];
    
//    CVNPSqliteManager *dao = [CVNPSqliteManager sharedCVNPSqliteManager];
//    CVNPSqliteManager *dao1 = [CVNPSqliteManager sharedCVNPSqliteManager];
//    
//    [dao InsertLocal:nil];
//    [dao1 InsertLocal:nil];
//    
//    NSArray *test = [[NSArray alloc] initWithArray:[dao QueryAllLocal]];
//    NSArray *test1 = [[NSArray alloc] initWithArray:[dao1 QueryAllLocal]];
//    [dao DeleteLocalById:1];
//    [dao UpdateLocalById:2 newPoint:nil];
    BFPaperButton *recordButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0, 0, 86, 86) raised:YES];
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [recordButton setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [recordButton addTarget:self action:@selector(recordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    recordButton.backgroundColor = [UIColor colorWithRed:0.3 green:0 blue:1 alpha:1];
    recordButton.tapCircleColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.6];  // Setting this color overrides "Smart Color".
    recordButton.cornerRadius = recordButton.frame.size.width / 2;
    recordButton.rippleFromTapLocation = NO;
    recordButton.rippleBeyondBounds = YES;
    recordButton.tapCircleDiameter = MAX(recordButton.frame.size.width, recordButton.frame.size.height) * 1.3;
    [_recordButtonView addSubview:recordButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view addSubview:_mapView];
    _mapView.centerCoordinate = _mapCenter;
    _mapView.zoom = 12;
    [self.view bringSubviewToFront:_tileSourceSegmentSwith];
    [self.view bringSubviewToFront:_recordButtonView];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Methods

- (IBAction)tileSourceSwith:(id)sender {
    if (_tileSourceSegmentSwith.selectedSegmentIndex == 0) {
        [_mapView setTileSource:_onlineTileSource];
    } else if (_tileSourceSegmentSwith.selectedSegmentIndex == 1) {
        [_mapView setTileSource:_offlineTileSource];
    }
}

- (void)recordButtonPressed:(id)sender {
    
}

@end
