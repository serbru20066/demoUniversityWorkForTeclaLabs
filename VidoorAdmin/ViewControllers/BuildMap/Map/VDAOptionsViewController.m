//
//  VDAOptionsViewController.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 16/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAOptionsViewController.h"
#import "VDAUITableViewCell.h"

static NSString *const kItemTypeBeaconNotification = @"addItemTypeBeaconNotification";
static NSString *const kItemTypeObstacleNotification = @"addItemTypeObstacleNotification";
static NSString *const kCreateSnapshootMapNotification = @"createSnapshootNotification";

@interface VDAOptionsViewController ()

@end

@implementation VDAOptionsViewController

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.options = [[NSArray alloc]initWithObjects:@"Insertar Beacon",@"Zona no transitable",@"Crear",@"Importar" ,nil];
    self.images = [[NSArray alloc]initWithObjects:@"menu_beacon",@"menu_obstacle",@"menu_create",@"menu_import" ,nil];
    self.selecteds = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0", nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void) selectAndDeselectCellOfIndexPath:(NSIndexPath*)indexPath {
    for (int i=0; i<self.selecteds.count; i++) {
        [self.selecteds replaceObjectAtIndex:i withObject:@"0"];
    }
    [self.selecteds replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [self.tableView reloadData];
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
    if ([[self.selecteds objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        cell.selectedStatus.image = [UIImage imageNamed:@"menu_selected"];
    } else {
        cell.selectedStatus.image = nil;
    }


    
    
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 159.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectAndDeselectCellOfIndexPath:indexPath];

    if (indexPath.row == 0) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kItemTypeBeaconNotification
         object:self];
        [self.tableView reloadData];
    }
    
    if (indexPath.row == 1) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kItemTypeObstacleNotification
         object:self];
    }
    
    if (indexPath.row == 2) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Quieres grabar este mapa?"
                                                                       message:@"Elige una opción"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Si"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"SI");
                                                              }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"No"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"NO");
                                                               }];
        
        [alert addAction:firstAction];
        [alert addAction:secondAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
    }
    if (indexPath.row == 3) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Importar Mapa"
                                                                       message:@"Elige una opción"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ir a la galería"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  NSLog(@"Ir a la galería");
                                                              }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Cancelar"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   NSLog(@"Cancelar");
                                                               }];
        
        [alert addAction:firstAction];
        [alert addAction:secondAction];
        [self presentViewController:alert animated:YES completion:nil];
    }

}


@end
