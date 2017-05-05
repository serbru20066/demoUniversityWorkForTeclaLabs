//
//  VDAUpdateSectionsViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/14/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "VDAUITextField.h"
#import "SKSpinner.h"
#import "JTAlertView.h"
#import "VDAPlace.h"
#import "VDASection.h"

@interface VDAUpdateSectionsViewController : VDABaseViewController

@property (weak, nonatomic) IBOutlet VDAUITextField *sectionNameTextField;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;
@property (nonatomic, strong) VDAPlace *place;
@property (nonatomic, strong) VDASection *section;

@end
