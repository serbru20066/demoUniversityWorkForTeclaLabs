//
//  VDAUpdateBeaconViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/16/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDAUITextField.h"
#import "VDABaseViewController.h"
#import "VDABeacon.h"
#import "SKSpinner.h"
#import "JTAlertView.h"

@interface VDAUpdateBeaconViewController : VDABaseViewController

@property (weak, nonatomic) IBOutlet VDAUITextField *identifierTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *majorTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *minorTextField;
@property (strong, nonatomic) VDABeacon *beacon;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;

@end
