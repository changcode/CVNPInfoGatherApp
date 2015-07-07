//
//  ViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//
#import "Config.h"

#import "CVNPViewController.h"
#import "CVNPPointPresentTableViewController.h"
#import "CVNPSqliteManager.h"

#import "BFPaperButton.h"
#import "UIColor+BFPaperColors.h"

#define kRegularSourceID   @"changshu1991.kal6f5d3"
#define kTerrainSourceID   @"changshu1991.l2e7f119"
#define kSatelliteSourceID @"changshu1991.l2e7o1mb"

#define kAccessKey @"pk.eyJ1IjoianVzdGluIiwiYSI6IlpDbUJLSUEifQ.4mG8vhelFMju6HpIY-Hi5A"

@interface CVNPViewController () <RMMapViewDelegate>

@property (strong, nonatomic) CVNPSqliteManager *DAO;
@property (strong, nonatomic) CVNPPointsModel *centerPoint;

@property (strong, nonatomic) RMMapView *mapView;
@property (strong, nonatomic) RMMapboxSource *onlineTileSource;
@property (strong, nonatomic) RMMBTilesSource *offlineTileSource;
@property (assign, nonatomic) CLLocationCoordinate2D startmapCenter;

@property (weak, nonatomic) IBOutlet UISegmentedControl *tileSourceSegmentSwith;
@property (weak, nonatomic) IBOutlet UIView *recordButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *centerPinImg;

@end

@implementation CVNPViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RMConfiguration sharedInstance] setAccessToken:kAccessKey];
    _onlineTileSource = [[RMMapboxSource alloc] initWithMapID:kRegularSourceID];
    _offlineTileSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"1-16_jpg_tiles" ofType:@"mbtiles"];
    
    _mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:_offlineTileSource];
    _startmapCenter = CLLocationCoordinate2DMake(41.2854277, -81.5656396);
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mapView.centerCoordinate = _startmapCenter;
    _mapView.zoom = 12;
    _mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = RMUserTrackingModeFollow;
    
    [self.view addSubview:_mapView];
    
    self.navigationItem.leftBarButtonItem = [[RMUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    
    _centerPoint = [[CVNPPointsModel alloc] init];

    _DAO = [CVNPSqliteManager sharedCVNPSqliteManager];

    BFPaperButton *recordButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(0, 0, 86, 86) raised:YES];
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [recordButton setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [recordButton addTarget:self action:@selector(recordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    recordButton.backgroundColor = [UIColor paperColorBlue];
    recordButton.tapCircleColor = [UIColor paperColorBlueA100];
    recordButton.cornerRadius = recordButton.frame.size.width / 2;
    recordButton.rippleFromTapLocation = NO;
    recordButton.rippleBeyondBounds = YES;
    recordButton.tapCircleDiameter = MAX(recordButton.frame.size.width, recordButton.frame.size.height) * 1.3;
    [_recordButtonView addSubview:recordButton];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:_tileSourceSegmentSwith];
    [self.view bringSubviewToFront:_recordButtonView];
    [self.view bringSubviewToFront:_centerPinImg];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self LoadAllLocalPoints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"GoCVNPPointDetailViewController"]) {
//        UINavigationController *navigationController = segue.destinationViewController;
//        CVNPPointDetailViewController *pdvc = [navigationController viewControllers][0];
//        [pdvc setCurrPoint:sender];
//    }
    if ([segue.identifier isEqualToString:@"GoCVNPPointPresentTableViewController"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CVNPPointPresentTableViewController *ppvc = [navigationController viewControllers][0];
        [ppvc setCurrentPoint:(CVNPPointsModel *)sender];
    }
}
        
#pragma mark - MapBox Methods
- (void)mapViewRegionDidChange:(RMMapView *)mapView
{
    [self.navigationItem setPrompt:[NSString stringWithFormat:@"%lf, %lf", _mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude]];
}

- (void)afterMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    [self.navigationItem setPrompt:nil];
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation) {
        return nil;
    }
    
    UIColor *metroBlue = [UIColor colorWithRed:0.01 green:0.22 blue:0.41 alpha:1];
    RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"rail-metro" tintColor:metroBlue];
    marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    marker.canShowCallout = YES;
    return marker;
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
//    [self performSegueWithIdentifier:@"GoCVNPPointDetailViewController" sender:annotation.userInfo];
    [self performSegueWithIdentifier:@"GoCVNPPointPresentTableViewController" sender:annotation.userInfo];
}

- (void)LoadAllLocalPoints
{
    [_mapView removeAllAnnotations];
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(backgroundQueue, ^(void)
    {
        NSArray *pointsInFMDB = [_DAO QueryAllLocal];
        for (CVNPPointsModel *Point in pointsInFMDB) {
            CLLocationCoordinate2D coordinate = {
                .longitude = [[Point Longitude] floatValue],
                .latitude = [[Point Latitude] floatValue]
            };
            RMAnnotation *one = [RMAnnotation annotationWithMapView:_mapView coordinate:coordinate andTitle:[Point Title]];
            one.userInfo = Point;
            [_mapView addAnnotation:one];
        }
    });
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
    [self setCenterPointwithMapboxCenterPoint];
//    [self performSegueWithIdentifier:@"GoCVNPPointDetailViewController" sender:_centerPoint];
    [self performSegueWithIdentifier:@"GoCVNPPointPresentTableViewController" sender:self.centerPoint];
}

#pragma mark - Ulti Methods

- (void)setCenterPointwithMapboxCenterPoint
{
    [_centerPoint setTitle:@""];
    [_centerPoint setDescription:@""];
    [_centerPoint setIsUpdated:NO];
    [_centerPoint setLongitude:[NSString stringWithFormat:@"%f", [_mapView centerCoordinate].longitude]];
    [_centerPoint setLatitude:[NSString stringWithFormat:@"%f", [_mapView centerCoordinate].latitude]];
    [_centerPoint setCreateDate:[self getCurrtimString]];
    [_centerPoint setIsCenter:YES];
    [_centerPoint setUser_ID:[Config getOwnID]];
    [_centerPoint setCategory:@""];
}

- (NSString *)getCurrtimString
{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yy/MM/dd HH:mm:ss"];
    NSString * Createdate = [df stringFromDate:currentDate];
    
    return Createdate;
}

@end
