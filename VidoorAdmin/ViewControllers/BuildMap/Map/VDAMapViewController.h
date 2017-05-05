//
//  VDAMapViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 16/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDAMapItem.h"
#import "VDAMapView.h"
#import "SKSpinner.h"
#import "VDAPlace.h"

@class VDAMapViewController;

@protocol VDAMapViewControllerDelegate <NSObject>

@required
- (void)vdaMapViewController:(VDAMapViewController*)sender invokeMyAnimationToTheMap:(VDAMapViewController*)map;
- (void)vdaMapViewController:(VDAMapViewController*)sender enableAndDisableNavigationButton:(VDAMapViewController*)map;

@end

@interface VDAMapViewController : UIViewController<VDAMapItemDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<VDAMapViewControllerDelegate>delegate;
@property (strong, nonatomic) VDAPlace *place;
@property (strong, nonatomic) VDAMapItem *img;
@property (assign, nonatomic) CGPoint touchOffset;
@property (assign, nonatomic) CGPoint homePosition;
@property (nonatomic) BOOL ifAllViewMoved;
//@property (strong, atomic) ALAssetsLibrary* mylibrary;
@property (strong, nonatomic) UIImageView *mySelectedPhoto;
@property (weak, nonatomic) IBOutlet VDAMapView *mapUIImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) SKSpinner *spinner;

- (BOOL)verifyIfAreItemsInCamp;
- (void)addShakeAnimationForAllItems;
- (void)animationOfView:(UIView*)img;
- (void)wobbleEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
