//
//  VDAHomeViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 14/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "JTAlertView.h"

@interface VDAHomeViewController : VDABaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) NSArray *images;
@property (nonatomic, strong) JTAlertView *alertView;

@end
