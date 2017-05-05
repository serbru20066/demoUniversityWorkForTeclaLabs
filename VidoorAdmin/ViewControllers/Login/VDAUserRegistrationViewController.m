//
//  VDAUserRegistrationViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/10/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "VDAUserRegistrationViewController.h"
#import "ImgurAnonymousAPIClient.h"

@interface VDAUserRegistrationViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDAUserRegistrationViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Registrar" andSecondLine:@"Usuario" withColor:[UIColor blackColor]];
    [self custonNavigationBar];
    [self customBackButtonInLightModalViewController];
    [self addTapGestureRecognizer];
}

#pragma mark -
#pragma mark - Private

- (void) initSpinnerAnimation {
    _animated = YES;
    self.view.userInteractionEnabled = NO;
    self.spinner = [[SKSpinner alloc] initWithView:self.view];
    self.spinner.minShowTime = 5.f;
    self.spinner.color = [UIColor lightGrayColor];
    [self.spinner showAnimated:YES];
}

- (void)addTapGestureRecognizer {
    [self.userImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.userImageView addGestureRecognizer:singleTap];
}

- (void)presentAlertViewConfirmation {
    
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"Se registró el usuario de manera exitosa" uppercaseString] andImage:[UIImage imageNamed:@"menu_profile"]];
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

#pragma mark -
#pragma mark - UIActions

- (IBAction)createUserAction:(id)sender {
    [self createUserOperation];
}

#pragma mark -
#pragma mark - Networking

- (void)createUserOperation {
    [self initSpinnerAnimation];
    UIImage *image = self.userImageView.image;
    [[ImgurAnonymousAPIClient client] uploadImage:image
                                     withFilename:@"image.jpg"
                                completionHandler:^(NSURL *imgurURL, NSError *error) {
                                    NSLog(@"%@",imgurURL);
                                    self.imageUrl = imgurURL;
                                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                                    NSDictionary *parameters = @{@"nombre" : self.userNameTextField.text,
                                                                 @"apellido" : self.userLastNameTextField.text,
                                                                 @"telefono" : self.phoneTextField.text,
                                                                 @"correo" : self.emailTextField.text,
                                                                 @"rol" : self.rolTextField.text,
                                                                 @"urlImagenUsuario" : self.imageUrl,
                                                                 @"usu" : self.userTextField.text,
                                                                 @"pass" : self.passwordTextField.text,};
                                    [manager POST:@"http://wsbeacons.somee.com/api/Usuarios" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSLog(@"JSON: %@", responseObject);
                                        [self.spinner removeFromSuperview];
                                        self.view.userInteractionEnabled = YES;
                                        [self presentAlertViewConfirmation];
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"Error: %@", error);
                                    }];
                                    
                                }];

}

#pragma mark -
#pragma mark - GestureRecognizer

-(void) handleSingleTap:(UITapGestureRecognizer *)gr {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            [self presentViewController:picker animated:YES completion:nil];
        });
    }];
}

#pragma mark -
#pragma mark - CTAssetsPickerController Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    [picker dismissViewControllerAnimated:YES completion:nil];
    PHAsset *asset = [assets objectAtIndex:0];
    PHImageManager *manager = [PHImageManager defaultManager];
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode =  PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [manager requestImageDataForAsset:asset
                              options:self.requestOptions
                        resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
     {
         UIImage *image = [UIImage imageWithData:imageData];
         self.userImageView.image = image;
         [self.userImageView.layer setCornerRadius:45.0f];
         [self.userImageView.layer setMasksToBounds:YES];
     }];
}


@end
