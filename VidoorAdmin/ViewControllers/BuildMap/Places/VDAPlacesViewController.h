//
//  VDAPlacesViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 10/23/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "VDAUITableViewCell.h"
#import "VDAPlace.h"
#import "SKSpinner.h"
#import "JTAlertView.h"

@interface VDAPlacesViewController : VDABaseViewController<UITableViewDataSource,UITableViewDelegate,VDAUITableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) NSString *urlMap;
@property (strong, nonatomic) VDAPlace *place;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;

@end
