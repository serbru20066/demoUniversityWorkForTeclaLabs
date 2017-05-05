//
//  VDAContainerViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 15/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAContainerViewController.h"

static NSString *const kOptionTVCSegueIdentifier = @"toOptionTVC";
static NSString *const kCampVC = @"toCampVC";

@interface VDAContainerViewController ()

@end

@implementation VDAContainerViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self customNavigationWithTitleInFirstLine:@"Crear" andSecondLine:@"Mapa" withColor:[UIColor blackColor]];
    [self custonNavigationBar];
    [self customBackButtonInModalViewController];
    [self customEditBarButtonInNavigationBar];
}

#pragma mark -
#pragma mark - Private

- (void)customEditBarButtonInNavigationBar {
    UIImage *buttonImage2 = [UIImage imageNamed:@"edit_navigation"];
    UIButton *aButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton2 setImage:buttonImage2 forState:UIControlStateNormal];
    aButton2.frame = CGRectMake(0.0,0.0,18,18);
    [aButton2 addTarget:self action:@selector(vdaMapViewController:invokeMyAnimationToTheMap:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton2 = [[UIBarButtonItem alloc] initWithCustomView:aButton2];
    self.navigationItem.rightBarButtonItem = backButton2;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark -
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kCampVC]) {
        destination = (VDAMapViewController*) segue.destinationViewController;
        destination.delegate = self;
        destination.place = self.place;
    }
}

#pragma mark -
#pragma mark - VDAMapViewController Delegate

- (void)vdaMapViewController:(VDAMapViewController*)sender enableAndDisableNavigationButton:(VDAMapViewController*)map {
    if ([destination verifyIfAreItemsInCamp])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

- (void)vdaMapViewController:(VDAMapViewController*)sender invokeMyAnimationToTheMap:(VDAMapViewController*)map {
    [destination addShakeAnimationForAllItems];
    
}

@end
