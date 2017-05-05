//
//  VDALoginViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 14/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VDABaseViewController.h"
#import "ILTranslucentView.h"
#import "VDAUITextField.h"
#import "SKSpinner.h"
#import "JTAlertView.h"

@interface VDALoginViewController : VDABaseViewController

@property (weak, nonatomic) IBOutlet VDAUITextField *userTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet ILTranslucentView *blurView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (strong, nonatomic) MPMoviePlayerController *introVideo;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;


@end
