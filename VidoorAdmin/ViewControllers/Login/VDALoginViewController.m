//
//  VDALoginViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 14/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "VDALoginViewController.h"
#import "Constants.pch"

@interface VDALoginViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDALoginViewController


#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVisualControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [self playIntroMovie];
    [self blurInit];
    [self addNotifacions];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeNotifications];
}

#pragma mark
#pragma mark - Private

- (void) initSpinnerAnimation {
    self.view.userInteractionEnabled = NO;
    self.spinner = [[SKSpinner alloc] initWithView:self.bannerView];
    self.spinner.minShowTime = 5.f;
    self.spinner.color = [UIColor whiteColor];
    [self.spinner showAnimated:YES];

}

- (void)initVisualControls {
    self.userTextField.text = @"admin1";
    self.passwordTextField.text = @"12345678";
    self.bannerView.backgroundColor = [UIColor clearColor];
}
- (void)playIntroMovie {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    self.introVideo = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [self.introVideo.view setFrame: CGRectMake(0, 0, screenWidth, screenHeight)];
    self.introVideo.controlStyle = MPMovieControlStyleNone;
    self.introVideo.scalingMode = MPMovieScalingModeAspectFill;
    self.introVideo.shouldAutoplay = YES;
    [self.introVideo play];
    [self.view addSubview:self.introVideo.view];
}
- (void)blurInit {
    self.blurView.translucentAlpha = 1.0;
    self.blurView.translucentTintColor = [UIColor clearColor];
    self.blurView.backgroundColor = [UIColor clearColor];
    self.blurView.translucentStyle = UIBarStyleBlackTranslucent;
    [self.view bringSubviewToFront:self.blurView];
}
- (void)introMovieFinished:(NSNotification *)notification {
    [self.introVideo play];
}

- (void)presentAlertViewConfirmation {
    
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"Ingrese usuario o contraseña correcto(a)" uppercaseString] andImage:[UIImage imageNamed:@"menu_profile"]];
    self.alertView.size = CGSizeMake(280, 230);
    self.alertView.popAnimation = YES;
    self.alertView.parallaxEffect = NO;
    self.alertView.backgroundShadow = YES;
    _animated = YES;
    __weak typeof(self)weakSelf = self;
    
    [self.alertView addButtonWithTitle:@"OK" font:[UIFont fontWithName:@"Avenir Next Condensed" size:14] style:JTAlertViewStyleDefault forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
        NSLog(@"JTAlertView: OK pressed");
        [alertView hideWithCompletion:nil animated:weakSelf.animated];
        [weakSelf goBackInModalViewController];
    }];
    [self.alertView showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:_animated];
    
    
}

#pragma mark
#pragma mark - Notifications

- (void)addNotifacions {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(introMovieFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.introVideo];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark
#pragma mark - IBActions

- (IBAction)loginAction:(id)sender {
    [self loginUserOperation];
}

#pragma mark -
#pragma mark - Networking

- (void)loginUserOperation {
    [self initSpinnerAnimation];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"usu" : self.userTextField.text,
                                 @"pass" : self.passwordTextField.text};
    NSString *url = [NSString stringWithFormat:@"%@%@",urlBase,@"/LoginUsuario"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self.spinner removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        [self performSegueWithIdentifier:@"loginSegueIdentifier" sender:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.spinner removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        [self presentAlertViewConfirmation];
    }];
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
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}


@end
