//
//  ViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/8/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPViewController.h"
#import "CVNPPointDetailViewController.h"
#import "CVNPSqliteManager.h"
#import "BFPaperButton.h"

#define kRegularSourceID   @"changshu1991.kal6f5d3"
#define kTerrainSourceID   @"changshu1991.l2e7f119"
#define kSatelliteSourceID @"changshu1991.l2e7o1mb"

#define kAccessKey @"pk.eyJ1IjoianVzdGluIiwiYSI6IlpDbUJLSUEifQ.4mG8vhelFMju6HpIY-Hi5A"

@interface CVNPViewController () <RMMapViewDelegate>

@property (strong, nonatomic) RMMapView *mapView;
@property (strong, nonatomic) RMMapboxSource *onlineTileSource;
@property (strong, nonatomic) RMMBTilesSource *offlineTileSource;
@property (assign, nonatomic) CLLocationCoordinate2D startmapCenter;

@property (strong, nonatomic) CVNPPointsModel *centerPoint;

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
    
    _startmapCenter = CLLocationCoordinate2DMake(41.2854277, -81.5656396);
    _mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:_offlineTileSource];
    
    [self.view addSubview:_mapView];
    _mapView.centerCoordinate = _startmapCenter;
    _mapView.zoom = 12;
    _mapView.delegate = self;
    
    _centerPoint = [[CVNPPointsModel alloc] init];
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

    [self.view bringSubviewToFront:_tileSourceSegmentSwith];
    [self.view bringSubviewToFront:_recordButtonView];
    [self.view bringSubviewToFront:_centerPinImg];
        NSLog(@"2");
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoCVNPPointDetailViewController"]) {
        NSLog(@"pre");
        
        UINavigationController *navigationController = segue.destinationViewController;
        CVNPPointDetailViewController *pdvc = [navigationController viewControllers][0];
        [pdvc setCurrPoint:_centerPoint];
    }
}

#pragma mark - MapBox Methods

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation) {
        return nil;
    }
    
    UIColor *metroBlue = [UIColor colorWithRed:0.01 green:0.22 blue:0.41 alpha:1];
    RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"rail-metro" tintColor:metroBlue];
    marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    marker.canShowCallout = YES;
//    NSSet *lines = annotation.userInfo[@"lines"];
//    StationDotsView *dots = [[StationDotsView alloc] initWithLines:lines];
//    marker.leftCalloutAccessoryView = dots;
//    
//    marker.hidden = [self annotationShouldBeHidden:annotation];
    return marker;
}

- (void)LoadPoints
{
    CLLocationCoordinate2D coordinate = [_mapView centerCoordinate];
    RMAnnotation *one = [RMAnnotation annotationWithMapView:_mapView coordinate:coordinate andTitle:@"test"];
    [_mapView addAnnotation:one];
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
//    CVNPPointDetailViewController *pdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CVNPPointDetailViewController"];
//    [self presentViewController:pdvc animated:YES completion: nil];
    [self LoadPoints];
    [self setCenterPointwithMapboxCenterPoint];
    [self performSegueWithIdentifier:@"GoCVNPPointDetailViewController" sender:sender];
    
}

#pragma mark - Ulti Methods

- (void)setCenterPointwithMapboxCenterPoint
{

    [_centerPoint setLongitude:[NSString stringWithFormat:@"%f", [_mapView centerCoordinate].longitude]];
    [_centerPoint setLatitude:[NSString stringWithFormat:@"%f", [_mapView centerCoordinate].latitude]];
    [_centerPoint setCreateDate:[self getCurrtimString]];
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
