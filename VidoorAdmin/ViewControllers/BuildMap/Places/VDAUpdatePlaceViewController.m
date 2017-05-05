//
//  VDAUpdatePlaceViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/7/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "VDAUpdatePlaceViewController.h"
#import "ImgurAnonymousAPIClient.h"

@interface VDAUpdatePlaceViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDAUpdatePlaceViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Actualizar" andSecondLine:@"Establecimiento" withColor:[UIColor whiteColor]];
    [self custonNavigationBar];
    [self customBackButtonInModalViewController];
    [self initializeVisualComponents];
    [self addTapGestureRecognizer];
}

#pragma mark -
#pragma mark - Private

- (void)initSpinnerAnimation {
    self.view.userInteractionEnabled = NO;
    self.spinner = [[SKSpinner alloc] initWithView:self.view];
    self.spinner.minShowTime = 5.f;
    self.spinner.color = [UIColor lightGrayColor];
    self.spinner.alpha = 0.7;
    [self.spinner showAnimated:YES];
}

- (void)initializeVisualComponents {
    NSString *cubedSymbol = @"\u00B2";
    NSString *m2 = [NSString stringWithFormat:@"m%@",cubedSymbol];
    self.helpStringSizeMatrix.text = [NSString stringWithFormat:@"Las medidas del establecimiento son en metros cuadrados (%@)",m2];
    self.namePlaceTextField.text = self.place.nom_estableci;
    self.addressTextField.text = self.place.direccion_estableci;
    self.rucTextField.text = self.place.ruc_estableci;
    self.UUIDTextField.text = self.place.UUIDBeacons;
    self.matrixSize.text = self.place.medidaMatriz;
    [self.placeImage.layer setCornerRadius:40.0f];
    [self.placeImage.layer setMasksToBounds:YES];
    [self.placeImage sd_setImageWithURL:[NSURL URLWithString:self.place.urlimagenReferencial]
                  placeholderImage:[UIImage imageNamed:@"menu_map"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         }]; 
}

#pragma mark -
#pragma mark - IBActions

- (IBAction)updatePlaceAction:(id)sender {
    if ([self isFormValid]) {
        [self updatePlaceOperationWithId:self.place.cod_estableci];
    }
}

#pragma mark -
#pragma mark - Networking

- (void)updatePlaceOperationWithId: (NSString*)idPlace {
    [self initSpinnerAnimation];
    UIImage *image = self.placeImage.image;
    [[ImgurAnonymousAPIClient client] uploadImage:image
                                     withFilename:@"image.jpg"
                                completionHandler:^(NSURL *imgurURL, NSError *error) {
                                    NSLog(@"%@",imgurURL);
                                    self.imageUrl = imgurURL;
                                    NSString *url = [NSString stringWithFormat:@"http://wsbeacons.somee.com/api/Establecimientoes/%@",idPlace];
                                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                                    NSDictionary *parameters = @{@"cod_estableci" : idPlace,
                                                                 @"nom_estableci" : self.namePlaceTextField.text,
                                                                 @"medidaMatriz" : self.matrixSize.text,
                                                                 @"direccion_estableci" : self.addressTextField.text,
                                                                 @"ruc_estableci" : self.rucTextField.text,
                                                                 @"urlimagenReferencial" : self.imageUrl,
                                                                 @"UUIDBeacons" : self.UUIDTextField.text};
                                    [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)addTapGestureRecognizer {
    [self.placeImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.placeImage addGestureRecognizer:singleTap];
}

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
         self.placeImage.image = image;
         [self.placeImage.layer setCornerRadius:40.0f];
         [self.placeImage.layer setMasksToBounds:YES];
     }];
}

#pragma mark -
#pragma mark - Validation

- (void)presentAlertViewConfirmation {
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"Se actualizó el establecimiento de manera exitosa" uppercaseString] andImage:[UIImage imageNamed:@"update_place_popup"]];
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

- (void)presentAlertViewConfirmationValidationWithText: (NSString*)description withCustomImageNamed:(NSString*)imageName {
    
    self.alertView = [[JTAlertView alloc] initWithTitle:[description uppercaseString] andImage:[UIImage imageNamed:imageName]];
    self.alertView.size = CGSizeMake(280, 230);
    self.alertView.popAnimation = YES;
    self.alertView.parallaxEffect = NO;
    self.alertView.backgroundShadow = YES;
    _animated = YES;
    __weak typeof(self)weakSelf = self;
    
    [self.alertView addButtonWithTitle:@"OK" font:[UIFont fontWithName:@"Avenir Next Condensed" size:14] style:JTAlertViewStyleDefault forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
        NSLog(@"JTAlertView: OK pressed");
        [alertView hideWithCompletion:nil animated:weakSelf.animated];
    }];
    [self.alertView showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:_animated];
    
    
}

- (BOOL) isFormValid {
    if (self.namePlaceTextField.text.length<1 && self.addressTextField.text.length<1 && self.rucTextField.text.length<1 && self.matrixSize.text.length<1 && self.UUIDTextField.text.length<1) {
        [self presentAlertViewConfirmationValidationWithText:@"Ingrese todos los campos" withCustomImageNamed:@"warning_popup"];
        return NO;
    }
    if (self.namePlaceTextField.text.length>0 && self.addressTextField.text.length>0 && self.rucTextField.text.length>0 && self.matrixSize.text.length>0 && self.UUIDTextField.text.length>0 && [self isMatrixSizeInputValidationString:self.matrixSize.text]) {
        NSLog(@"CORRECTO");
        return YES;
    }
    if (self.namePlaceTextField.text.length>0 && self.addressTextField.text.length>0 && self.rucTextField.text.length>0 && self.matrixSize.text.length>0 && self.UUIDTextField.text.length>0 && ![self isMatrixSizeInputValidationString:self.matrixSize.text]) {
        [self presentAlertViewConfirmationValidationWithText:@"Las medidas del establecimiento no son correctas. Ejemplo, 90x60. Debe ingresar números enteros" withCustomImageNamed:@"warning_popup"];
        return NO;
    }
    if (self.namePlaceTextField.text.length<1 || self.addressTextField.text.length<1 || self.rucTextField.text.length<1 || self.matrixSize.text.length<1 || self.UUIDTextField.text.length<1) {
        [self presentAlertViewConfirmationValidationWithText:@"Ingrese todos los campos" withCustomImageNamed:@"warning_popup"];
        return NO;
    }
    
    return YES;
}
@end
