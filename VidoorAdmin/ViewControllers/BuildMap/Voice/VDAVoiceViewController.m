//
//  VDAVoiceViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/14/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "VDAVoiceViewController.h"
#import "VDAVoiceCommand.h"
#import "VDAUpdateVoiceViewController.h"
#import "VDAAddVoiceViewController.h"
#import "VDANavigationController.h"

@interface VDAVoiceViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDAVoiceViewController

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Mis comandos" andSecondLine:@" de voz" withColor:[UIColor whiteColor]];
    [self custonNavigationBar];
    [self customBackButtonInModalViewController];
    [self customAddVoiceCommandButtonInNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSpinnerAnimation];
    [self getMyVoiceCommandsOperation];
}

#pragma mark -
#pragma mark - Private

- (void) initSpinnerAnimation {
    self.spinner = [[SKSpinner alloc] initWithView:self.view];
    self.spinner.minShowTime = 5.f;
    self.spinner.color = [UIColor whiteColor];
    [self.spinner showAnimated:YES];
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToAddVoiceCommandViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDAAddVoiceViewController *addVoiceCommandViewController = (VDAAddVoiceViewController *)([navController viewControllers][0]);
        addVoiceCommandViewController.section = self.section;
    }
    if ([segue.identifier isEqualToString:@"goToUpdateVoiceCommandViewVController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDAUpdateVoiceViewController *updateVoiceCommandViewController = (VDAUpdateVoiceViewController *)([navController viewControllers][0]);
        updateVoiceCommandViewController.voiceCommand = self.voiceCommand;
    }
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.voices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"VDAUITableViewCell";
    VDAUITableViewCell *cell = (VDAUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
        cell = [[VDAUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1){
        [cell drawCircleOfTimeLine];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = ((VDAVoiceCommand*)[self.voices objectAtIndex:indexPath.row]).descripcion_dato;
    cell.image.image = [UIImage imageNamed:@"voice_item"];
    cell.delegate = self;

    return cell;
}

#pragma mark -
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 159.0f;
}

#pragma mark -
#pragma mark - VDAUITableViewCell Delegate

- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender UpdateItemSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.voiceCommand = [self.voices objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"goToUpdateVoiceCommandViewVController" sender:self];
    NSLog(@"ACTUALIZA");
}
- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender DeleteItemSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell {
    [self presentAlertViewConfirmation];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.voiceCommand = [self.voices objectAtIndex:indexPath.row];
    NSLog(@"ELIMINA %ld",(long)indexPath.row);
}

- (void) vdaUITableViewCell:(VDAUITableViewCell *)sender reproduceVoiceCommandAndDisableOptionsOffCell:(VDAUITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.voiceCommand = [self.voices objectAtIndex:indexPath.row];
    [self reproduceAudioOfString:self.voiceCommand.descripcion_dato];
}
#pragma mark -
#pragma mark - Networking

- (void)getMyVoiceCommandsOperation {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{};
    [manager GET:@"http://wsbeacons.somee.com/api/DatosVozs" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self fillVoiceCommandsArray:responseObject];
        [self.spinner removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)deleteVoiceCommandOperationWithId:(NSString*)idVoiceCommand {
    [self initSpinnerAnimation];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id" : idVoiceCommand};
    
    [manager DELETE:@"http://wsbeacons.somee.com/api/DatosVozs" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self getMyVoiceCommandsOperation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)filterVoicesWithId:(NSString *)idSection {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"codSeccion LIKE %@", idSection];
    NSArray *filteredArray = [[NSArray alloc] initWithArray:[self.voices filteredArrayUsingPredicate:predicate]];
    self.voices = [[NSMutableArray alloc] initWithArray:[filteredArray mutableCopy]];
    NSLog(@"%@",filteredArray);
}

- (void) fillVoiceCommandsArray:(id)responseObject {
    self.voices = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDic in responseObject){
        VDAVoiceCommand *voice = [VDAVoiceCommand new];
        NSString *id_dato = [[itemDic objectForKey:@"id_dato"] stringValue];
        NSString *codSeccion = [[itemDic objectForKey:@"codSeccion"] stringValue];
        NSString *descripcion_dato = [itemDic objectForKey:@"descripcion_dato"];
        voice.id_dato = id_dato;
        voice.descripcion_dato = descripcion_dato;
        voice.codSeccion = codSeccion;
        [self.voices addObject:voice];
    }
    NSLog(@"%@",self.voices);
    [self filterVoicesWithId:self.section.codSeccion];
    [self.tableView reloadData];
}

#pragma mark -
#pragma marl - Validation

- (void)presentAlertViewConfirmation {
    
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"¿Está seguro que desea eliminar este comando de voz?" uppercaseString] andImage:[UIImage imageNamed:@"delete_place_popup"]];
    self.alertView.size = CGSizeMake(280, 230);
    self.alertView.popAnimation = YES;
    self.alertView.parallaxEffect = NO;
    self.alertView.backgroundShadow = YES;
    _animated = YES;
    __weak typeof(self)weakSelf = self;
    
    [self.alertView addButtonWithTitle:@"CANCELAR" font:[UIFont fontWithName:@"Avenir Next Condensed" size:14] style:JTAlertViewStyleDefault forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
        NSLog(@"JTAlertView: CANCEL pressed");
        [alertView hideWithCompletion:nil animated:weakSelf.animated];
    }];
    [self.alertView addButtonWithTitle:@"ELIMINAR" font:[UIFont fontWithName:@"Avenir Next Condensed" size:14] style:JTAlertViewStyleDestructive forControlEvents:UIControlEventTouchUpInside action:^(JTAlertView *alertView) {
        NSLog(@"JTAlertView: DELETE pressed");
        [alertView hideWithCompletion:nil animated:weakSelf.animated];
        [weakSelf deleteVoiceCommandOperationWithId:weakSelf.voiceCommand.id_dato];
    }];
    [self.alertView showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:_animated];
}
@end
