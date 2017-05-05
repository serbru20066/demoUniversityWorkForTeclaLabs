//
//  VDASectionsOptionsViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/14/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import "VDASectionsOptionsViewController.h"
#import "VDAUITableViewCell.h"
#import "VDAVoiceViewController.h"
#import "VDABeaconsViewController.h"
#import "VDANavigationController.h"

@interface VDASectionsOptionsViewController ()

@end

@implementation VDASectionsOptionsViewController

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Elija una" andSecondLine:@"opción" withColor:[UIColor whiteColor]];
    [self custonNavigationBar];
    [self customBackButtonInModalViewController];
    NSLog(@"nombre: %@  codigo:%@",self.section.nomSeccion,self.section.codSeccion);
}

- (void)viewWillAppear:(BOOL)animated {
    self.options = [[NSArray alloc]initWithObjects:@"Mis comandos de voz",@"Mis iBeacons", nil];
    self.images = [[NSArray alloc]initWithObjects:@"voicecommand",@"menu_beacon",nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToBeaconsViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDABeaconsViewController *beaconsViewController = (VDABeaconsViewController *)([navController viewControllers][0]);
        beaconsViewController.section = self.section;
    }
    if ([segue.identifier isEqualToString:@"goToVoiceCommandsViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDAVoiceViewController *voiceViewController = (VDAVoiceViewController *)([navController viewControllers][0]);
        voiceViewController.section = self.section;
    }
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
    
    if (indexPath.row == 1) {
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
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"goToVoiceCommandsViewController" sender:self];
    }
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"goToBeaconsViewController" sender:self];
    }
}

@end
