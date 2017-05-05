//
//  VDAMapItemView.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 10/24/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAMapItemView.h"

@implementation VDAMapItemView

#pragma mark -
#pragma mark - Lifecycle

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.7;
        [self initializeComponents];
    }
    return self;
}

#pragma mark -
#pragma mark - Private Methods

- (void)initializeComponents {
    [self setUserInteractionEnabled:YES];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItemOfMap:)];
    self.tapRecognizer.numberOfTouchesRequired = 1;
    [self.tapRecognizer setCancelsTouchesInView:NO];
    [self addGestureRecognizer:self.tapRecognizer];
    self.isSelected = NO;
}

- (void)tapItemOfMap:(UITapGestureRecognizer *)recognizer {
    if (!self.isSelected){
        self.backgroundColor = [UIColor redColor];
        self.isSelected = YES;
        return;
    }
    else {
        self.backgroundColor = [UIColor clearColor];
        self.isSelected = NO;
        return;
    }

}

#pragma mark -
#pragma mark - Public Methods

- (void) setStatusOfItem {
    if (!self.isSelected && self.userInteractionEnabled == YES){
        self.backgroundColor = [UIColor redColor];
        self.isSelected = YES;
        return;
    } 
}
@end
