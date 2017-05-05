//
//  VDAMapView.m
//  VidoorAdmin
//
//  Created by Bruno Cardenas on 10/24/15.
//  Copyright © 2015 Bruno Cardenas. All rights reserved.
//

#import "VDAMapView.h"
#import "VDAMapItemView.h"
#import "VDAMapItem.h"

static NSString *const kItemTypeBeaconNotification = @"addItemTypeBeaconNotification";
static NSString *const kItemTypeObstacleNotification = @"addItemTypeObstacleNotification";

@implementation VDAMapView

#pragma mark -
#pragma mark - Lifecycle

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addNotifications];

    }
    return self;
}

#pragma mark -
#pragma mark - Public

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addBeaconToCamp)
                                                 name:kItemTypeBeaconNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addObstacleToCamp)
                                                 name:kItemTypeObstacleNotification
                                               object:nil];
    
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kItemTypeBeaconNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kItemTypeObstacleNotification object:nil];
}
- (void) createGridOfMapWithCGRect:(CGRect)frame andWidthM2:(NSString*)width andHeightM2:(NSString*)height {
    int cont = 1;
    self.widthSpace = frame.size.width/[width intValue];
    self.heightSpace = frame.size.height/[height intValue];
    
    for (int k=0; k<90; k++) {
        UIView *column = [[UIView alloc]initWithFrame:CGRectMake(self.widthSpace*k, 0,1,frame.size.height)];
        column.backgroundColor = [UIColor blackColor];
        column.alpha = 0.8;
        [self addSubview:column];
    }
    
    for (int k=0; k<60; k++) {
        UIView *row = [[UIView alloc]initWithFrame:CGRectMake(0, self.heightSpace*k,frame.size.width,1)];
        row.backgroundColor = [UIColor blackColor];
        row.alpha = 0.8;
        [self addSubview:row];
    }
    
    for (int i=0; i<90; i++) {
        for (int j=0; j<60; j++) {
            VDAMapItemView *item = [[VDAMapItemView alloc]initWithFrame:CGRectMake(self.widthSpace*i, self.heightSpace*j,self.widthSpace,self.heightSpace)];
            item.backgroundColor = [UIColor clearColor];
            item.tag = cont;
            [self addSubview:item];
            cont++;
        }
    }
    
    [self enableOrDisableInteractionOfAMapItemsOfKind:1 andStatus:NO];
    [self enableOrDisableInteractionOfAMapItemsOfKind:3 andStatus:YES];
}

- (void)addBeaconToCamp {
    VDAMapItem *item = [[VDAMapItem alloc] initWithFrame:CGRectMake(100, 100, 50, 50) withType:1];
    item.delegate = self;
    [item setUserInteractionEnabled:YES];
    [self addSubview:item];
    [self enableOrDisableInteractionOfAMapItemsOfKind:1 andStatus:NO];
    [self enableOrDisableInteractionOfAMapItemsOfKind:2 andStatus:NO];
    [self enableOrDisableInteractionOfAMapItemsOfKind:3 andStatus:YES];
}

- (void)addObstacleToCamp {
    [self enableOrDisableInteractionOfAMapItemsOfKind:1 andStatus:YES];
    [self enableOrDisableInteractionOfAMapItemsOfKind:2 andStatus:YES];
    [self enableOrDisableInteractionOfAMapItemsOfKind:3 andStatus:NO];
}

- (void)enableOrDisableInteractionOfAMapItemsOfKind:(int)kind andStatus:(BOOL) status {
    
    if (kind == 1) {
        for (VDAMapItemView *iView in self.subviews) {
            if ([iView isMemberOfClass:[VDAMapItemView class]]) {
                [iView setUserInteractionEnabled:status];
            }
        }
    }
    if (kind == 2) {
        for (VDAMapItem *iView in self.subviews) {
            if ([iView isMemberOfClass:[VDAMapItem class]]) {
                [iView setHidden:status];
            }
        }
    }
    if (kind == 3) {
        for (UIView *iView in self.subviews) {
            if ([iView isMemberOfClass:[UIView class]]) {
                [iView setHidden:status];
            }
        }
    }

}
#pragma mark -
#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        if ([touches count] == 1) {
            CGPoint touchPoint = [[touches anyObject] locationInView:self];
            for (UIView *iView in self.subviews) {
                if ([iView isMemberOfClass:[VDAMapItemView class]]) {
                    if (touchPoint.x > iView.frame.origin.x &&
                        touchPoint.x < iView.frame.origin.x + self.widthSpace &&
                        touchPoint.y > iView.frame.origin.y &&
                        touchPoint.y < iView.frame.origin.y + self.heightSpace)
                        {
                        self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                       touchPoint.y - iView.frame.origin.y);
                        self.homePosition = CGPointMake(iView.frame.origin.x,iView.frame.origin.y);
                        }
                }
                if ([iView isMemberOfClass:[VDAMapItem class]]) {
                    if (touchPoint.x > iView.frame.origin.x &&
                        touchPoint.x < iView.frame.origin.x + 50 &&
                        touchPoint.y > iView.frame.origin.y &&
                        touchPoint.y < iView.frame.origin.y + 50)
                        {
                            self.item = (VDAMapItem*)iView;
                            self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                           touchPoint.y - iView.frame.origin.y);
                            self.homePosition = CGPointMake(iView.frame.origin.x,iView.frame.origin.y);
                            [self bringSubviewToFront:self.item];
                        }
                    }
                }
        }
    
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        
        for (UIView *iView in self.subviews) {
            if ([iView isMemberOfClass:[VDAMapItemView class]]) {
                
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + self.widthSpace &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + self.heightSpace)
                {
                    [(VDAMapItemView*)iView setStatusOfItem];
                    
                }
            }
            if ([iView isMemberOfClass:[VDAMapItem class]]) {
                
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + 50 &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + 50)
                {
                    NSLog(@"moving");
                    CGRect newDragObjectFrame = CGRectMake(touchPoint.x - self.touchOffset.x,touchPoint.y - self.touchOffset.y,50,50);
                    self.item.frame = newDragObjectFrame;
                    
                }
            }
        }
    
    
    
}

@end
