//
//  RefreshPullToReactView.m
//  ExampleCustomContent
//
//  Created by Guillaume Sempe on 04/06/2014.
//  Copyright (c) 2014 mention.com. All rights reserved.
//

#import "RefreshPullToReactView.h"

#import "CKRefreshArrowView.h"

@interface RefreshPullToReactView ()
@property(nonatomic) CKRefreshArrowView *arrow;
@end

@implementation RefreshPullToReactView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect frame = CGRectInset(self.bounds, 12, 12);
        _arrow = [[CKRefreshArrowView alloc] initWithFrame:frame];
        _arrow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_arrow];
        _arrow.center = self.center;
    }
    return self;
}

/*
 - (void)willTriggerAction:(NSInteger)action
 {
 
 }
- (void)didTriggerAction:(NSInteger)action
{
    self.lastChannel = action;
}
 - (void)willDoAction:(NSInteger)action
 {
 
 }
 */

- (void)didDoAction:(NSInteger)action
{
}

- (void)didMoveTo:(CGPoint)point
{
    // Update the progress arrow
    CGFloat pullHeight = point.y;
    CGFloat triggerHeight = self.bounds.size.height;
    CGFloat progress = pullHeight / triggerHeight;
    CGFloat deadZone = 0.3;
    if (progress > deadZone) {
        CGFloat arrowProgress = ((progress - deadZone) / (1 - deadZone));
        self.arrow.progress = arrowProgress;
    }
    else {
        self.arrow.progress = 0.0;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint center =(CGPoint){
        .x = CGRectGetMidX(self.bounds),
        .y = CGRectGetMidY(self.bounds)
    };
    
    self.arrow.center = center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
