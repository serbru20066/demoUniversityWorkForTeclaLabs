//
//  VDAUpdateVoiceViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/16/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "VDAUpdateVoiceViewController.h"

@interface VDAUpdateVoiceViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDAUpdateVoiceViewController

#pragma mark -
#pragma mark - Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Actualizar comando" andSecondLine:@" de voz" withColor:[UIColor whiteColor]];
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
    NSLog(@"nombre: %@  codigo seccion: %@",self.voiceCommand.descripcion_dato,self.voiceCommand.codSeccion);
    self.descriptionVoiceTextField.text = self.voiceCommand.descripcion_dato;
}

#pragma mark -
#pragma mark - IBActions

- (IBAction)updateVoiceCommandAction:(id)sender {
    if ([self isFormValid]) {
        [self updateVoiceCommandOperationWithId:self.voiceCommand.id_dato];
    }
}


#pragma mark -
#pragma mark - Networking

- (void)updateVoiceCommandOperationWithId: (NSString*)idCommandVoice {
    [self initSpinnerAnimation];
    NSString *url = [NSString stringWithFormat:@"http://wsbeacons.somee.com/api/DatosVozs/%@",idCommandVoice];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id_dato" : idCommandVoice,
                                 @"descripcion_dato" : self.descriptionVoiceTextField.text,
                                 @"codSeccion" : self.voiceCommand.codSeccion};
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
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"Se actualizó el comando de voz de manera exitosa" uppercaseString] andImage:[UIImage imageNamed:@"update_place_popup"]];
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
        [self presentAlertViewConfirmationValidationWithText:@"Complete el campo" withCustomImageNamed:@"warning_popup"];
        return NO;
    }
    
    return YES;
}

@end
