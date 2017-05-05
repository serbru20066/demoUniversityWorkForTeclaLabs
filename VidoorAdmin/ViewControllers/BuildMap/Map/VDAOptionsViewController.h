//
//  VDAOptionsViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 16/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDAOptionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSMutableArray *selecteds;
 
@end
