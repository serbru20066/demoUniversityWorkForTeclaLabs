//
//  VDASectionsViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/13/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "VDAPlace.h"
#import "VDASection.h"
#import "VDAUITableViewCell.h"
#import "SKSpinner.h"
#import "JTAlertView.h"

@interface VDASectionsViewController : VDABaseViewController<UITableViewDataSource,UITableViewDelegate,VDAUITableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) SKSpinner *spinner;
@property (strong, nonatomic) VDAPlace *place;
@property (strong, nonatomic) VDASection *section;
@property (nonatomic, strong) JTAlertView *alertView;

@end
