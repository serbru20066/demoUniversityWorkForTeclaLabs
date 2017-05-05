//
//  VDAUITableViewCell.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 15/10/15.
//  Copyright (c) 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAUITableViewCell.h"

@implementation VDAUITableViewCell

#pragma mark -
#pragma mark - Lifecycle

- (void)awakeFromNib {
    [self addPanGestureRecognizer];
    [self.gestureCampView setBackgroundColor:[UIColor clearColor]];
    UIView *circle1 = [[UIView alloc]initWithFrame:CGRectMake(53, 0, 9, 9)];
    circle1.backgroundColor = [UIColor whiteColor];
    [circle1.layer setCornerRadius:4.5f];
    [circle1.layer setMasksToBounds:YES];
    [self addSubview:circle1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark - Public

- (void) drawCircleOfTimeLine {
    UIView *circle2 = [[UIView alloc]initWithFrame:CGRectMake(53, 150, 9, 9)];
    circle2.backgroundColor = [UIColor whiteColor];
    [circle2.layer setCornerRadius:4.5f];
    [circle2.layer setMasksToBounds:YES];
    [self addSubview:circle2];
}


#pragma mark -
#pragma mark - Private

- (void)showOptionsForGestureRecognizerWithStatus:(BOOL) status {
    if (status) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.optionsView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }else {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.optionsView.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
    
}

#pragma mark -
#pragma mark - IBActions

- (IBAction)updatePlaceAction:(id)sender {
    [self showOptionsForGestureRecognizerWithStatus:NO];
    [self.delegate vdaUITableViewCell:self UpdateItemSegueAndDisableOptionsOffCell:self];
    
}

- (IBAction)deletePlaceAction:(id)sender {
    [self showOptionsForGestureRecognizerWithStatus:NO];
    [self.delegate vdaUITableViewCell:self DeleteItemSegueAndDisableOptionsOffCell:self];
}

- (IBAction)showMapAction:(id)sender {
    [self showOptionsForGestureRecognizerWithStatus:NO];
    [self.delegate vdaUITableViewCell:self showMapSegueAndDisableOptionsOffCell:self];
}
- (IBAction)reproduceVoiceCommandAction:(id)sender {
    [self showOptionsForGestureRecognizerWithStatus:NO];
    [self.delegate vdaUITableViewCell:self reproduceVoiceCommandAndDisableOptionsOffCell:self];
}

#pragma mark -
#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark -
#pragma mark - GestureRecognizer

- (void)addPanGestureRecognizer {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.minimumNumberOfTouches = 1;
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown,
        UIPanGestureRecognizerDirectionLeft,
        UIPanGestureRecognizerDirectionRight
    };
    
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            
            if (direction == UIPanGestureRecognizerDirectionUndefined) {
                
                CGPoint velocity = [sender velocityInView:self];
                
                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                
                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown;
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp;
                    }
                }
                
                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight;
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft;
                    }
                }
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    [self handleUpwardsGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: {
                    [self handleDownwardsGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: {
                    [self handleLeftGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: {
                    [self handleRightGesture:sender];
                    break;
                }
                default: {
                    break;
                }
            }
        }
            
        case UIGestureRecognizerStateEnded: {
            direction = UIPanGestureRecognizerDirectionUndefined;
            break;
        }
            
        default:
            break;
    }
    
}
- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender {
    NSLog(@"Up");
}

- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender {
    NSLog(@"Down");
}

- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender {
    NSLog(@"Left");
    [self showOptionsForGestureRecognizerWithStatus:YES];
}

- (void)handleRightGesture:(UIPanGestureRecognizer *)sender {
    NSLog(@"Right");
    [self showOptionsForGestureRecognizerWithStatus:NO];
}


@end
