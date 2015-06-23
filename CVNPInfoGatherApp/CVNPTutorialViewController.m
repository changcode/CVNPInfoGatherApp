//
//  CVNPTutorialViewController.m
//  CVNPInfoGatherApp
//
//  Created by Chang on 6/21/15.
//  Copyright (c) 2015 Kent State University. All rights reserved.
//

#import "CVNPTutorialViewController.h"
#import "Config.h"

@interface CVNPTutorialViewController () <ICETutorialControllerDelegate>

@end

@implementation CVNPTutorialViewController

- (void)viewDidLoad {

    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"Discovery"
                                                            subTitle:@"CVNP Info Gather App"
                                                         pictureName:@"tutorial1"
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"CVNP"
                                                            subTitle:@"Some CVNP Image From Flickr"
                                                         pictureName:@"tutorial2"
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"View"
                                                            subTitle:@"Some CVNP Image From Flickr"
                                                         pictureName:@"tutorial3"
                                                            duration:3.0];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"View"
                                                            subTitle:@"Some CVNP Image From Flickr"
                                                         pictureName:@"tutorial4"
                                                            duration:3.0];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@"View"
                                                            subTitle:@"Some CVNP Image From Flickr"
                                                         pictureName:@"tutorial5"
                                                            duration:3.0];
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];
    
    // Set the common style for the title.
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    // Init tutorial.
    [super initWithPages:tutorialLayers delegate:self];
    [super viewDidLoad];
    // Run it.
    [self startScrolling];
}
-(void)awakeFromNib
{
    if ([self validateLogined]) {
        [self performSegueWithIdentifier:@"GoCVNPViewController" sender:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
//    NSLog(@"Scrolling from page %lu to page %lu.", (unsigned long)fromIndex, (unsigned long)toIndex);
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
//    NSLog(@"Tutorial reached the last page.");
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"GoCVNPLoginRegistrationFormViewController" sender:nil];
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"GoCVNPViewController" sender:nil];
}

- (BOOL)validateLogined
{
    if (![[Config getOwnID] isEqualToString:@""]) {
        NSLog(@"already login");
        return YES;
    } else {
        NSLog(@"NOOO");
        return NO;
    }
}

@end
