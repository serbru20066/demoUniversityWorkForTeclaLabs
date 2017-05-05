//
//  VDAUserRegistrationViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/10/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "VDAUITextField.h"
#import "SKSpinner.h"
#import "JTAlertView.h"

@interface VDAUserRegistrationViewController : VDABaseViewController<CTAssetsPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet VDAUITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *userLastNameTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *emailTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *rolTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *userTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *passwordTextField;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@property (strong, nonatomic) NSURL *imageUrl;

@end
