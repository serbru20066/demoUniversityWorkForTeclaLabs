//
//  VDAUIButton.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 14/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAUIButton.h"

@implementation VDAUIButton

#pragma mark
#pragma mark - Lifecycle

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self.layer setCornerRadius:5.0f];
        [self.layer setMasksToBounds:YES];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
