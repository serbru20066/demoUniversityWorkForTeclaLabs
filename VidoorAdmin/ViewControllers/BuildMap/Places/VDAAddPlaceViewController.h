//
//  VDAAddPlaceViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/6/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "VDAUITextField.h"
#import "VDAMatrixSizeTextField.h"
#import "SKSpinner.h"
#import "JTAlertView.h"

@interface VDAAddPlaceViewController : VDABaseViewController<CTAssetsPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet VDAUITextField *namePlaceTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *addressTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *rucTextField;
@property (weak, nonatomic) IBOutlet VDAUITextField *UUIDTextField;
@property (weak, nonatomic) IBOutlet VDAMatrixSizeTextField *matrixSize;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *helpStringSizeMatrix;
@property (weak, nonatomic) IBOutlet UIImageView *imagePlaceImageView;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@property (strong, nonatomic) NSURL *imageUrl;
@end
