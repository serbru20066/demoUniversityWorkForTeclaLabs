//
//  VDAPlacesViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 10/23/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "VDAPlacesViewController.h"
#import "VDAUITableViewCell.h"
#import "VDAContainerViewController.h"
#import "VDADetailNavigationController.h"
#import "VDANavigationController.h"
#import "VDAPlace.h"
#import "VDAUpdatePlaceViewController.h"
#import "VDASectionsViewController.h"

@interface VDAPlacesViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDAPlacesViewController


#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Mis" andSecondLine:@"Establecimientos" withColor:[UIColor whiteColor]];
    [self custonNavigationBar];
    [self customBackButtonInModalViewController];
    [self customAddPlaceButtonInNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSpinnerAnimation];
    [self getMyPlacesOperation];
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToSectionsViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDASectionsViewController *sectionsViewController = (VDASectionsViewController *)([navController viewControllers][0]);
        sectionsViewController.place = self.place;
    }
    
    if ([segue.identifier isEqualToString:@"buildMapSegueIdentifier"]){
        VDADetailNavigationController *navController = [segue destinationViewController];
        VDAContainerViewController *containerMapViewController = (VDAContainerViewController *)([navController viewControllers][0]);
        containerMapViewController.place = self.place;
    }
    if ([segue.identifier isEqualToString:@"goToUpdatePlaceViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDAUpdatePlaceViewController *updatePlaceViewController = (VDAUpdatePlaceViewController *)([navController viewControllers][0]);
        updatePlaceViewController.place = self.place;
    }
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
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
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
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = ((VDAPlace*)[self.places objectAtIndex:indexPath.row]).nom_estableci;
    cell.image.image = [UIImage imageNamed:@"menu_map"];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:((VDAPlace*)[self.places objectAtIndex:indexPath.row]).urlimagenReferencial]
                           placeholderImage:[UIImage imageNamed:@"menu_map"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  }];
    [cell.image.layer setCornerRadius:35.0f];
    [cell.image.layer setMasksToBounds:YES];
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 159.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.place = [self.places objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"GoToSectionsViewController" sender:self];
}

#pragma mark -
#pragma mark - Networking

- (void)getMyPlacesOperation {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{};
    [manager GET:@"http://wsbeacons.somee.com/api/Establecimientoes" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self fillPlacesArray:responseObject];
        [self.spinner removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)deletePlaceOperationWithId:(NSString*)idPlace {
    [self initSpinnerAnimation];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id" : idPlace};
    
    [manager DELETE:@"http://wsbeacons.somee.com/api/Establecimientoes" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self getMyPlacesOperation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void) fillPlacesArray:(id)responseObject {
    self.places = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDic in responseObject){
        
        VDAPlace * place = [VDAPlace new];
        NSString *cod_estableci = [[itemDic objectForKey:@"cod_estableci"]stringValue];
        NSString *nom_estableci = (NSString *)[itemDic objectForKey:@"nom_estableci"];
        NSString *medidaMatriz = (NSString *)[itemDic objectForKey:@"medidaMatriz"];
        NSString *ruc_estableci = (NSString *)[itemDic objectForKey:@"ruc_estableci"];
        NSString *urlimagenReferencial = (NSString *)[itemDic objectForKey:@"urlimagenReferencial"];
        NSString *direccion_estableci = (NSString *)[itemDic objectForKey:@"direccion_estableci"];
        NSString *UUIDBeacons = (NSString *)[itemDic objectForKey:@"UUIDBeacons"];
        
        place.cod_estableci = cod_estableci;
        place.nom_estableci = nom_estableci;
        place.medidaMatriz = medidaMatriz;
        place.ruc_estableci = ruc_estableci;
        place.urlimagenReferencial = urlimagenReferencial;
        place.direccion_estableci = direccion_estableci;
        place.UUIDBeacons = UUIDBeacons;
        
        [self.places addObject:place];
    }
    NSLog(@"%@",self.places);
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - VDAUITableViewCell Delegate

- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender UpdateItemSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.place = [self.places objectAtIndex:indexPath.row];;
    [self performSegueWithIdentifier:@"goToUpdatePlaceViewController" sender:self];
    NSLog(@"ACTUALIZA");
}
- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender DeleteItemSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell {
    [self presentAlertViewConfirmation];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.place = [self.places objectAtIndex:indexPath.row];
    NSLog(@"ELIMINA %ld",(long)indexPath.row);
}

- (void) vdaUITableViewCell:(VDAUITableViewCell *)sender showMapSegueAndDisableOptionsOffCell:(VDAUITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.place = [self.places objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"buildMapSegueIdentifier" sender:self];
}
#pragma mark -
#pragma mark - Validation

- (void)presentAlertViewConfirmation {
    
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"¿Está seguro que desea eliminar este establecimiento?" uppercaseString] andImage:[UIImage imageNamed:@"delete_place_popup"]];
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
        [weakSelf deletePlaceOperationWithId:weakSelf.place.cod_estableci];
    }];
    [self.alertView showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:_animated];
}

@end
