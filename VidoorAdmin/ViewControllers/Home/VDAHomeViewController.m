//
//  VDAHomeViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 14/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAHomeViewController.h"
#import "VDAUITableViewCell.h"
#import "VDAPlacesViewController.h"
#import "VDAPlace.h"

@interface VDAHomeViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDAHomeViewController

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.options = [[NSArray alloc]initWithObjects:@"Mi perfil",@"Establecimientos",@"Acerca de",@"Cerrar Sesión" ,nil];
    self.images = [[NSArray alloc]initWithObjects:@"menu_profile",@"menu_map",@"menu_information",@"menu_logout" ,nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self customNavigationWithTitleInFirstLine:@"Vidoor" andSecondLine:@"Admin" withColor:[UIColor whiteColor]];
    [self custonNavigationBar];
}

#pragma mark -
#pragma mark - Private

- (void)presentAlertViewConfirmation {
    
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"¿Está seguro que desea cerrar sesión?" uppercaseString] andImage:[UIImage imageNamed:@"logout_popup"]];
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
    [self.alertView addButtonWithTitle:@"CANCELAR" font:[UIFont fontWithName:@"Avenir Next Condensed" size:14] style:JTAlertViewStyleCancel forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
        NSLog(@"JTAlertView: CANCEL pressed");
        [alertView hideWithCompletion:nil animated:weakSelf.animated];
    }];

    [self.alertView showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:_animated];
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"VDAUITableViewCell";
    VDAUITableViewCell *cell = (VDAUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
        cell = [[VDAUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if (indexPath.row == 3) {
        [cell drawCircleOfTimeLine];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = [self.options objectAtIndex:indexPath.row];
    cell.image.image = [UIImage imageNamed:[self.images objectAtIndex:indexPath.row]];

    return cell;
}

#pragma mark -
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 159.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"placesSegueIdentifier" sender:self];
    }
    if (indexPath.row == 3) {
        [self presentAlertViewConfirmation];
    }
}

@end
