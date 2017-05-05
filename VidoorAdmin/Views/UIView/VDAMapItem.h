//
//  VDAMapItem.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 16/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VDAMapItem;

@protocol VDAMapItemDelegate <NSObject>

@required
-(void) vdaMapItem:(VDAMapItem*)sender itemDeletedOnMap:(VDAMapItem*)item;

@end

@interface VDAMapItem : UIView

@property (assign, nonatomic) id<VDAMapItemDelegate> delegate;
@property (nonatomic, strong) UIImageView *itemImage;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (assign, nonatomic) BOOL isAnimated;

-(id) initWithFrame:(CGRect)frame withType:(int)type;

@end
