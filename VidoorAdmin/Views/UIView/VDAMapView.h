//
//  VDAMapView.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 10/24/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDAMapItem.h"

@interface VDAMapView : UIImageView<VDAMapItemDelegate>

@property (assign, nonatomic) CGPoint touchOffset;
@property (assign, nonatomic) CGPoint homePosition;
@property (assign, nonatomic) CGFloat widthSpace;
@property (assign, nonatomic) CGFloat heightSpace;
@property (strong,nonatomic) VDAMapItem *item;

-(id) initWithFrame:(CGRect)frame;
- (void) createGridOfMapWithCGRect:(CGRect)frame andWidthM2:(NSString*)width andHeightM2:(NSString*)height;
- (void)addNotifications;
- (void)removeNotifications;
@end
