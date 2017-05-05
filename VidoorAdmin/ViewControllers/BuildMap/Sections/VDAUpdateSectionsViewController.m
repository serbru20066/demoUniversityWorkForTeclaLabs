//
//  VDAUpdateSectionsViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/14/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "VDAUpdateSectionsViewController.h"

@interface VDAUpdateSectionsViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDAUpdateSectionsViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Actualizar" andSecondLine:@"Seccion" withColor:[UIColor whiteColor]];
    [self custonNavigationBar];
    [self customBackButtonInModalViewController];
    [self initializeVisualComponents];
}

#pragma mark -
#pragma mark - Private

- (void)initSpinnerAnimation {
    _animated = YES;
    self.view.userInteractionEnabled = NO;
    self.spinner = [[SKSpinner alloc] initWithView:self.view];
    self.spinner.minShowTime = 5.f;
    self.spinner.color = [UIColor whiteColor];
    self.spinner.alpha = 0.7;
    [self.spinner showAnimated:YES];
}

- (void)initializeVisualComponents {
    self.sectionNameTextField.text = self.section.nomSeccion;
}

#pragma mark -
#pragma mark - IBActions

- (IBAction)updateSectionAction:(id)sender {
    if ([self isFormValid]) {
        [self updateSectionOperationWithId:self.section.codSeccion];
    }
}

#pragma mark -
#pragma mark - Networking

- (void)updateSectionOperationWithId: (NSString*)idPlace {
    [self initSpinnerAnimation];
    NSString *url = [NSString stringWithFormat:@"http://wsbeacons.somee.com/api/Seccions/%@",idPlace];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"codSeccion" : idPlace,
                                 @"nomSeccion" : self.sectionNameTextField.text,
                                 @"cod_estableci" : self.place.cod_estableci};
    [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self.spinner removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        [self presentAlertViewConfirmation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark -
#pragma mark - Validation

- (void)presentAlertViewConfirmation {
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"Se actualizó la sección de manera exitosa" uppercaseString] andImage:[UIImage imageNamed:@"update_place_popup"]];
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
    if (self.sectionNameTextField.text.length<1) {
        [self presentAlertViewConfirmationValidationWithText:@"Complete el campo" withCustomImageNamed:@"warning_popup"];
        return NO;
    }
    
    return YES;
}


@end
