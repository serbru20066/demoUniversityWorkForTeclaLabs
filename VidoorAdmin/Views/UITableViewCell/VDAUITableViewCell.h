//
//  VDAUITableViewCell.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 15/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VDAUITableViewCell;

@protocol VDAUITableViewCellDelegate <NSObject>

@required
- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender UpdateItemSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell;
- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender DeleteItemSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell;
@optional
- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender showMapSegueAndDisableOptionsOffCell:(VDAUITableViewCell*)cell;
- (void) vdaUITableViewCell:(VDAUITableViewCell*)sender reproduceVoiceCommandAndDisableOptionsOffCell:(VDAUITableViewCell*)cell;

@end

@interface VDAUITableViewCell : UITableViewCell

@property (assign, nonatomic) id<VDAUITableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *selectedStatus;
@property (weak, nonatomic) IBOutlet UIView *optionsView;
@property (weak, nonatomic) IBOutlet UIView *gestureCampView;


- (void) drawCircleOfTimeLine;
- (void)showOptionsForGestureRecognizerWithStatus:(BOOL) status;
@end
