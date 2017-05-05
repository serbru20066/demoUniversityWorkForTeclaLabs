//
//  VDAUpdateVoiceViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/16/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDAUITextField.h"
#import "VDABaseViewController.h"
#import "VDAVoiceCommand.h"
#import "SKSpinner.h"
#import "JTAlertView.h"

@interface VDAUpdateVoiceViewController : VDABaseViewController

@property (weak, nonatomic) IBOutlet VDAUITextField *descriptionVoiceTextField;
@property (strong, nonatomic) VDAVoiceCommand *voiceCommand;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;


@end
