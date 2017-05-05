//
//  VDAContainerViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 15/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "VDAMapViewController.h"
#import "VDAPlace.h"

@interface VDAContainerViewController : VDABaseViewController<VDAMapViewControllerDelegate>
{
    VDAMapViewController *destination;
}
@property (strong, nonatomic) VDAPlace *place;
@end
