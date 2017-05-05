//
//  VDABaseViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 15/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDABaseViewController : UIViewController

- (void)customNavigationWithTitleInFirstLine:(NSString *)firstLine andSecondLine:(NSString*)secondLine withColor:(UIColor*)color;

- (void)goBackInModalViewController;
- (void)goBackInPushedViewController;

- (void)custonNavigationBar;
- (void)customBackButtonInModalViewController;
- (void)customBackButtonInLightModalViewController;
- (void)customBackButtonInNavigationBar;
- (void)customAddPlaceButtonInNavigationBar;
- (void)customAddSectionButtonInNavigationBar;
- (void)customAddVoiceCommandButtonInNavigationBar;
- (void)customAddBeaconButtonInNavigationBar;

- (BOOL)isMatrixSizeInputValidationString:(NSString*)value;
- (void) reproduceAudioOfString:(NSString*)textToSpeech;
@end
