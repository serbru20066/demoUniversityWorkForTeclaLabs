//
//  VDASectionsViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/13/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "VDASectionsViewController.h"
#import "VDAddSectionsViewController.h"
#import "VDASectionsOptionsViewController.h"
#import "VDAUpdateSectionsViewController.h"
#import "VDANavigationController.h"
#import "VDASection.h"

@interface VDASectionsViewController ()

@property (nonatomic, assign) bool animated;

@end

@implementation VDASectionsViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationWithTitleInFirstLine:@"Mis" andSecondLine:@"Secciones" withColor:[UIColor whiteColor]];
    [self custonNavigationBar];
    [self customBackButtonInModalViewController];
    [self customAddSectionButtonInNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSpinnerAnimation];
    [self getMySectionsOperation];
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToAddSectionViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDAddSectionsViewController *addSectionViewController = (VDAddSectionsViewController *)([navController viewControllers][0]);
        addSectionViewController.place = self.place;
    }
    if ([segue.identifier isEqualToString:@"goToUpdateSectionViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDAUpdateSectionsViewController *updateSectionViewController = (VDAUpdateSectionsViewController *)([navController viewControllers][0]);
        updateSectionViewController.place = self.place;
        updateSectionViewController.section = self.section;
    }
    if ([segue.identifier isEqualToString:@"goToSectionsOptionsViewController"]){
        VDANavigationController *navController = [segue destinationViewController];
        VDASectionsOptionsViewController *sectionsOptionsViewController = (VDASectionsOptionsViewController *)([navController viewControllers][0]);
        sectionsOptionsViewController.section = self.section;
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
    return self.sections.count;
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
    cell.title.text = ((VDASection*)[self.sections objectAtIndex:indexPath.row]).nomSeccion;
    cell.image.image = [UIImage imageNamed:@"menu_map"];
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
    self.section = [self.sections objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"goToSectionsOptionsViewController" sender:self];
}

#pragma mark -
#pragma mark - VDAUITableViewCell Delegate

- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender UpdateItemSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.section = [self.sections objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"goToUpdateSectionViewController" sender:self];
    NSLog(@"ACTUALIZA");
}
- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender DeleteItemSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell {
    [self presentAlertViewConfirmation];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.section = [self.sections objectAtIndex:indexPath.row];
    NSLog(@"ELIMINA %ld",(long)indexPath.row);
}

#pragma mark -
#pragma mark - Networking

- (void)getMySectionsOperation {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{};
    [manager GET:@"http://wsbeacons.somee.com/api/Seccions" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self fillSectionsArray:responseObject];
        [self.spinner removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)filterSectionsWithId:(NSString *)idPlace {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cod_estableci LIKE %@", idPlace];
    NSArray *filteredArray = [[NSArray alloc] initWithArray:[self.sections filteredArrayUsingPredicate:predicate]];
    self.sections = [[NSMutableArray alloc] initWithArray:[filteredArray mutableCopy]];
    NSLog(@"%@",filteredArray);
}

- (void)deleteSectionOperationWithId:(NSString*)idPlace {
    [self initSpinnerAnimation];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"id" : idPlace};
    
    [manager DELETE:@"http://wsbeacons.somee.com/api/Seccions" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self getMySectionsOperation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void) fillSectionsArray:(id)responseObject {
    self.sections = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDic in responseObject){
        VDASection *section = [VDASection new];
        NSString *cod_estableci = [[itemDic objectForKey:@"cod_estableci"] stringValue];
        NSString *codSeccion = [[itemDic objectForKey:@"codSeccion"] stringValue];
        NSString *nomSeccion = [itemDic objectForKey:@"nomSeccion"];
        section.cod_estableci = cod_estableci;
        section.nomSeccion = nomSeccion;
        section.codSeccion = codSeccion;
        [self.sections addObject:section];
    }
    [self filterSectionsWithId:self.place.cod_estableci];
    [self.tableView reloadData];
}

#pragma mark -
#pragma marl - Validation

- (void)presentAlertViewConfirmation {
    
    self.alertView = [[JTAlertView alloc] initWithTitle:[@"¿Está seguro que desea eliminar esta sección?" uppercaseString] andImage:[UIImage imageNamed:@"delete_place_popup"]];
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
        [weakSelf deleteSectionOperationWithId:weakSelf.section.codSeccion];
    }];
    [self.alertView showInSuperview:[[UIApplication sharedApplication] keyWindow] withCompletion:nil animated:_animated]; 
}

@end
