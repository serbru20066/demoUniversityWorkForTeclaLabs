//
//  VDABeaconsViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/16/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "VDAUITableViewCell.h"
#import "SKSpinner.h"
#import "JTAlertView.h"
#import "VDASection.h"
#import "VDABeacon.h"

@interface VDABeaconsViewController : VDABaseViewController<UITableViewDelegate,UITableViewDataSource,VDAUITableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *beacons;
@property (strong, nonatomic) SKSpinner *spinner;
@property (nonatomic, strong) JTAlertView *alertView;
@property (strong, nonatomic) VDASection *section;
@property (strong, nonatomic) VDABeacon *beacon;

@end
