//
//  VDAUITextField.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 14/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAUITextField.h"

@implementation VDAUITextField

#pragma mark
#pragma mark - Lifecycle

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setKeyboardAppearance:UIKeyboardAppearanceDark];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
