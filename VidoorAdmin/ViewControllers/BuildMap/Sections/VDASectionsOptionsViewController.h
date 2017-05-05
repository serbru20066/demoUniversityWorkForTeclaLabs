//
//  VDASectionsOptionsViewController.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/14/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDABaseViewController.h"
#import "VDASection.h"

@interface VDASectionsOptionsViewController : VDABaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) VDASection *section;

@end
