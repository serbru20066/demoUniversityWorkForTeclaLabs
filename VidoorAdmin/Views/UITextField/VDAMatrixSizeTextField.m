//
//  VDAMatrixSizeTextField.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 11/13/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAMatrixSizeTextField.h"

@implementation VDAMatrixSizeTextField

#pragma mark
#pragma mark - Lifecycle

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setKeyboardAppearance:UIKeyboardAppearanceDark];
        self.delegate = self;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789x"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![myCharSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    return YES;
}

@end
