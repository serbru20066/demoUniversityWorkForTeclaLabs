//
//  VDAAddVoiceViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/16/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "VDAUITextField.h"
#import "SKSpinner.h"
#import "JTAlertView.h"
#import "VDASection.h"

@interface VDAAddVoiceViewController : VDABaseViewController

@property (weak, nonatomic) IBOutlet VDAUITextField *descriptionVoiceTextField;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;
@property (strong, nonatomic) VDASection *section;

@end
