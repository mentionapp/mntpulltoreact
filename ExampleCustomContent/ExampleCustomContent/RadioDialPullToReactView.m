//
//  RadioDialPullToReactView.m
//  ExampleCustomContent
//
//  Created by Guillaume Sempe on 02/06/2014.
//  Copyright (c) 2014 mention.com. All rights reserved.
//

#import "RadioDialPullToReactView.h"

@interface RadioDialPullToReactView ()
@property(nonatomic, assign) NSInteger lastChannel;
@property(nonatomic, assign) CGPoint location;
@end

@implementation RadioDialPullToReactView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _lastChannel = NSNotFound;
        _location = CGPointZero;
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radiodialbg"]];
        bg.frame = ({
            CGRect frame = bg.frame;
            frame.origin.y = self.bounds.size.height - frame.size.height;
            frame;
        });
        [self addSubview:bg];
    }
    return self;
}

/*
- (void)willTriggerAction:(NSInteger)action
{
    
}
*/
- (void)didTriggerAction:(NSInteger)action
{
    self.lastChannel = action;
}
/*
- (void)willDoAction:(NSInteger)action
{
    
}
 */

- (void)didDoAction:(NSInteger)action
{
    if ([self.radioDialDelegate respondsToSelector:@selector(radioDial:didSelectChannel:)]) {
        [self.radioDialDelegate radioDial:self didSelectChannel:action];
    }
}

- (void)didMoveTo:(CGPoint)point
{
    self.location = point;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    {
        // Draw whatever you like
        CGColorRef bgColor = [UIColor colorWithRed:0xf6/255. green:0xf6/255. blue:0xf4/255. alpha:1].CGColor;
        CGContextSetFillColorWithColor(ctx, bgColor);
        CGContextFillRect(ctx, self.bounds);
        
         CGContextSetLineCap(ctx, kCGLineCapSquare);
         CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0xab/255. green:0xa1/255. blue:0x97/255. alpha:0.5].CGColor);
         CGContextSetLineWidth(ctx, 1.0);
         CGContextMoveToPoint(ctx, self.location.x + 0.5, 0);
         CGContextAddLineToPoint(ctx, self.location.x + 0.5, self.frame.size.height + 0.5);
         CGContextStrokePath(ctx);
        
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0xab/255. green:0xa1/255. blue:0x97/255. alpha:0.5].CGColor);
        NSString *text = [NSString stringWithFormat:@"Select channel %d", self.lastChannel];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]}];
        CGPoint textOrigin = CGPointZero;
        if (self.location.x*2 > self.bounds.size.width) {
            textOrigin = CGPointMake(self.location.x - 10 - textSize.width, self.bounds.size.height - textSize.height - 25);
        } else {
            textOrigin = CGPointMake(self.location.x + 10, self.bounds.size.height - textSize.height - 25);
        }
        
        [text drawInRect:(CGRect){textOrigin,textSize} withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]}];

    }
    CGContextRestoreGState(ctx);
}

@end
