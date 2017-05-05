//
//  VDABaseViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 15/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "VDABaseViewController.h"

@interface VDABaseViewController ()

@end

@implementation VDABaseViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark - Public

- (BOOL)isMatrixSizeInputValidationString:(NSString *)value {
    NSString * str = value;
    NSArray * arr = [str componentsSeparatedByString:@"x"];
    if (arr.count == 2) {
        int width = [[arr objectAtIndex:0] intValue];
        int heigth = [[arr objectAtIndex:1]intValue];
        
        if (width==0 || heigth==0) {
            return NO;
        } else {
            NSLog(@"%@",arr);
            return YES;
        }
        
    }else {
        return NO;
    }
}
#pragma mark -
#pragma mark - Private

- (void)customNavigationWithTitleInFirstLine:(NSString *)firstLine andSecondLine:(NSString*)secondLine withColor:(UIColor*)color{
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, -2, 180, 44)];
    container.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(-8, -3, 170, 40)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = firstLine;
    title.textColor = color;
    title.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14];
    [container addSubview:title];
    
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, 170, 40)];
    title2.textAlignment = NSTextAlignmentCenter;
    title2.text = secondLine;
    title2.textColor = color;
    title2.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14];
    [container addSubview:title2];
    
    self.navigationItem.titleView = container;
}

- (void)customBackButtonInModalViewController {
    UIImage *buttonImage = [UIImage imageNamed:@"x_navigation"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0,0.0,18,18);
    [aButton addTarget:self action:@selector(goBackInModalViewController)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)customBackButtonInLightModalViewController {
    UIImage *buttonImage = [UIImage imageNamed:@"x_navigation_photos"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0,0.0,18,18);
    [aButton addTarget:self action:@selector(goBackInModalViewController)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)customBackButtonInNavigationBar {
    UIImage *buttonImage = [UIImage imageNamed:@"back2.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0,0.0,18,18);
    [aButton addTarget:self action:@selector(goBackInPushedViewController)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)customAddPlaceButtonInNavigationBar {
    UIImage *buttonImage = [UIImage imageNamed:@"add_navigation"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0,0.0,18,18);
    [aButton addTarget:self action:@selector(goToAddPlaceViewController)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)customAddSectionButtonInNavigationBar {
    UIImage *buttonImage = [UIImage imageNamed:@"add_navigation"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0,0.0,18,18);
    [aButton addTarget:self action:@selector(goToAddSectionViewController)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)customAddVoiceCommandButtonInNavigationBar {
    UIImage *buttonImage = [UIImage imageNamed:@"add_navigation"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0,0.0,18,18);
    [aButton addTarget:self action:@selector(goToAddVoiceCommandViewController)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)customAddBeaconButtonInNavigationBar {
    UIImage *buttonImage = [UIImage imageNamed:@"add_navigation"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0,0.0,18,18);
    [aButton addTarget:self action:@selector(goToAddBeaconViewController)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void) reproduceAudioOfString:(NSString*)textToSpeech {
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:textToSpeech];
    utterance.rate = 0.45;
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"es-ES"];
    [synth speakUtterance:utterance];
}
#pragma mark -
#pragma mark - Navigation

- (void)custonNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)goBackInModalViewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)goBackInPushedViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToAddPlaceViewController {
    [self performSegueWithIdentifier:@"goToAddPlaceViewController" sender:self];
}

- (void)goToAddSectionViewController {
    [self performSegueWithIdentifier:@"goToAddSectionViewController" sender:self];
}

- (void)goToAddVoiceCommandViewController {
    [self performSegueWithIdentifier:@"goToAddVoiceCommandViewController" sender:self];
}

- (void)goToAddBeaconViewController {
    [self performSegueWithIdentifier:@"goToAddBeaconViewController" sender:self];
}

#pragma mark
#pragma mark - StatusBar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
