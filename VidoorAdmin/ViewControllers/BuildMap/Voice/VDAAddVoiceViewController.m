//
//  VDAAddVoiceViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/16/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "VDAAddVoiceViewController.h"
#import "Constants.pch"

@interface VDAAddVoiceViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDAAddVoiceViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Agregar comando" andSecondLine:@"de voz" withColor:[UIColor whiteColor]];
    [self custonNavigationBar];
    [self customBackButtonInModalViewController];
    NSLog(@"codigoSeccion :%@",self.section.codSeccion);
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

#pragma mark -
#pragma mark - IBActions

- (IBAction)addVoiceCommandAction:(id)sender {
    if ([self isFormValid]) {
        [self addVoiceCommandOperation];
    }
}

#pragma mark -
#pragma mark - Networking

- (void)addVoiceCommandOperation {
    [self initSpinnerAnimation];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"descripcion_dato" : self.descriptionVoiceTextField.text,
                                 @"codSeccion" : self.section.codSeccion,};
    NSString *url = [NSString stringWithFormat:@"%@%@",urlBase,@"/DatosVozs"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self.spinner removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        [self presentAlertViewConfirmationRequest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark -
#pragma mark - Validation

- (void)presentAlertViewConfirmationRequest {
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"Se agregó un nuevo comando de voz de manera exitosa" uppercaseString] andImage:[UIImage imageNamed:@"voicecommand_popup"]];
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
    if (self.descriptionVoiceTextField.text.length<1) {
        [self presentAlertViewConfirmationValidationWithText:@"Ingrese todos los campos" withCustomImageNamed:@"warning_popup"];
        return NO;
    }
    
    return YES;
}
@end
