//
//  VDABeaconsViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/16/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "VDABeaconsViewController.h"
#import "VDABeacon.h"
#import "VDANavigationController.h"
#import "VDAUpdateBeaconViewController.h"
#import "VDAAddBeaconViewController.h"
#import "Constants.pch"
#import "Constants.pch"

@interface VDABeaconsViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDABeaconsViewController

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Mis" andSecondLine:@"iBeacons" withColor:[UIColor whiteColor]];
    [self custonNavigationBar];
    [self customBackButtonInModalViewController];
    [self customAddBeaconButtonInNavigationBar];

}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSpinnerAnimation];
    [self getMyBeaconsOperation];
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
    if ([segue.identifier isEqualToString:@"goToUpdateBeaconViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDAUpdateBeaconViewController *updateBeaconViewController = (VDAUpdateBeaconViewController *)([navController viewControllers][0]);
        updateBeaconViewController.beacon = self.beacon;
    }
    if ([segue.identifier isEqualToString:@"goToAddBeaconViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDAAddBeaconViewController *addBeaconViewController = (VDAAddBeaconViewController *)([navController viewControllers][0]);
        addBeaconViewController.section = self.section;
    }
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beacons.count;
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
    NSString *MajorAndMinorString = [NSString stringWithFormat:@"%@ \nMajor: %@ \nMinor: %@",((VDABeacon*)[self.beacons objectAtIndex:indexPath.row]).alias,((VDABeacon*)[self.beacons objectAtIndex:indexPath.row]).Major,((VDABeacon*)[self.beacons objectAtIndex:indexPath.row]).Minor];
    cell.title.text = MajorAndMinorString;
    cell.image.image = [UIImage imageNamed:@"beacon_item"];
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
    self.beacon = [self.beacons objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"goToUpdateBeaconViewController" sender:self];
    NSLog(@"ACTUALIZA");
}
- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender DeleteItemSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell {
    [self presentAlertViewConfirmation];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.beacon = [self.beacons objectAtIndex:indexPath.row];
    NSLog(@"ELIMINA %ld",(long)indexPath.row);
}

#pragma mark -
#pragma mark - Networking

- (void)getMyBeaconsOperation {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{};
    NSString *url = [NSString stringWithFormat:@"%@%@",urlBase,@"/iBeacons"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self fillBeaconsArray:responseObject];
        [self.spinner removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)deleteBeaconOperationWithId:(NSString*)idBeacon {
    [self initSpinnerAnimation];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id" : idBeacon};
    NSString *url = [NSString stringWithFormat:@"%@%@",urlBase,@"/iBeacons"];
    [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self getMyBeaconsOperation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }]; 
}

- (void)filterBeaconsWithId:(NSString *)idSection {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"codSeccion LIKE %@", idSection];
    NSArray *filteredArray = [[NSArray alloc] initWithArray:[self.beacons filteredArrayUsingPredicate:predicate]];
    self.beacons = [[NSMutableArray alloc] initWithArray:[filteredArray mutableCopy]];
    NSLog(@"%@",filteredArray);
}

- (void) fillBeaconsArray:(id)responseObject {
    self.beacons = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDic in responseObject){
        VDABeacon *beacon = [VDABeacon new];
        NSString *idiBeacon = [[itemDic objectForKey:@"idiBeacon"] stringValue];
        NSString *codSeccion = [[itemDic objectForKey:@"codSeccion"] stringValue];
        NSString *alias = [itemDic objectForKey:@"alias"];
        NSString *Major = [itemDic objectForKey:@"Major"];
        NSString *Minor = [itemDic objectForKey:@"Minor"];
        beacon.idiBeacon = idiBeacon;
        beacon.codSeccion = codSeccion;
        beacon.alias = alias;
        beacon.Major = Major;
        beacon.Minor = Minor;
        [self.beacons addObject:beacon];
    }
    NSLog(@"%@",self.beacons);
    [self filterBeaconsWithId:self.section.codSeccion];
    [self.tableView reloadData];
}

#pragma mark -
#pragma marl - Validation

- (void)presentAlertViewConfirmation {
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"¿Está seguro que desea eliminar este iBeacon?" uppercaseString] andImage:[UIImage imageNamed:@"delete_place_popup"]];
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
        [weakSelf deleteBeaconOperationWithId:weakSelf.beacon.idiBeacon];
    }];
    [self.alertView showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:_animated];
}
@end
