//
//  VDADetailNavigationController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 15/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import "VDADetailNavigationController.h"

@interface VDADetailNavigationController ()

@end

@implementation VDADetailNavigationController

#pragma mark -
#pragma mark - Private

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark
#pragma mark - StatusBar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - Interface Orientation

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
