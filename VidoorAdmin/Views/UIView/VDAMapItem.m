//
//  VDAMapItem.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 16/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAMapItem.h"

@implementation VDAMapItem

#pragma mark -
#pragma mark - Lifecycle

-(id) initWithFrame:(CGRect)frame withType:(int)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInitWihType:type];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

-(void) baseInitWihType:(int)type {
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteItemOnMap:)];
    self.tapRecognizer.numberOfTouchesRequired = 1;
    
    self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    [self.deleteButton setImage:[[UIImage imageNamed:@"remove_file"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.deleteButton addGestureRecognizer:self.tapRecognizer];
    
    if (type == 1)
    {
        self.itemImage =  [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 30, 38)];
        self.itemImage.image = [UIImage imageNamed:@"beacon"];
    }
    else
    {
        self.itemImage =  [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 37, 38)];
        self.itemImage.image = [UIImage imageNamed:@"obstacle"];
    }
    [self addSubview:self.itemImage];
    [self addSubview:self.deleteButton];
    [self setIsAnimated:NO];
}

#pragma mark -
#pragma mark - Private Methods

- (void)deleteItemOnMap:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.alpha=0.0f;
        self.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.delegate vdaMapItem:self itemDeletedOnMap:self];
        
    }];
    
}
- (void)setIsAnimated:(BOOL)isAnimated {
    if (isAnimated)
        [self.deleteButton setHidden:NO];
    else
        [self.deleteButton setHidden:YES];
    
    _isAnimated = isAnimated;
}

@end
