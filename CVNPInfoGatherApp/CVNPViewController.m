//
//  ViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPViewController.h"
#import "CVNPSqliteManager.h"

#define kRegularSourceID   @"changshu1991.kal6f5d3"
#define kTerrainSourceID   @"changshu1991.l2e7f119"
#define kSatelliteSourceID @"changshu1991.l2e7o1mb"

#define kAccessKey @"pk.eyJ1IjoianVzdGluIiwiYSI6IlpDbUJLSUEifQ.4mG8vhelFMju6HpIY-Hi5A"

@interface CVNPViewController ()

@property (strong, nonatomic) RMMapView *mapView;
@property (strong, nonatomic) RMMapboxSource *onlineTileSource;
@property (strong, nonatomic) RMMBTilesSource *offlineTileSource;
@property (assign, nonatomic) CLLocationCoordinate2D mapCenter;

@end

@implementation CVNPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RMConfiguration sharedInstance] setAccessToken:kAccessKey];
    _onlineTileSource = [[RMMapboxSource alloc] initWithMapID:kRegularSourceID];
    _offlineTileSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"1-16_jpg_tiles" ofType:@"mbtiles"];
    
    _mapCenter = CLLocationCoordinate2DMake(41.2854277, -81.5656396);
    _mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:_offlineTileSource];
    
    CVNPSqliteManager *dao = [CVNPSqliteManager sharedCVNPSqliteManager];
    CVNPSqliteManager *dao1 = [CVNPSqliteManager sharedCVNPSqliteManager];
    
    [dao InsertLocal:nil];
    [dao1 InsertLocal:nil];
    
    NSArray *test = [[NSArray alloc] initWithArray:[dao QueryAllLocal]];
    NSArray *test1 = [[NSArray alloc] initWithArray:[dao1 QueryAllLocal]];
    [dao DeleteLocalById:1];
    [dao UpdateLocalById:2 newPoint:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view addSubview:_mapView];
    _mapView.centerCoordinate = _mapCenter;
    _mapView.zoom = 12;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
