//
//  VDAMapItemView.h
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 10/24/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDAMapItemView : UIView

-(id) initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (assign, nonatomic) BOOL isSelected;

- (void) setStatusOfItem;
@end
