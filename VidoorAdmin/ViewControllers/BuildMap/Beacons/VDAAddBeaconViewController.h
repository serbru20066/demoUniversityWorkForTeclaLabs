//
//  VDAAddBeaconViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/16/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDAUITextField.h"
#import "VDABaseViewController.h"
#import "SKSpinner.h"
#import "JTAlertView.h"
#import "VDASection.h"
@interface VDAAddBeaconViewController : VDABaseViewController

@property (weak, nonatomic) IBOutlet VDAUITextField *identifierTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *majorTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *minorTextField;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;
@property (strong, nonatomic) VDASection *section;
@end
