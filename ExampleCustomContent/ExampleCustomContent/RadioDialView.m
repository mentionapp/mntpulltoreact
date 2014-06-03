//
//  RadioDialView.m
//  ExampleCustomContent
//
//  Created by Guillaume Sempe on 02/06/2014.
//  Copyright (c) 2014 mention.com. All rights reserved.
//

#import "RadioDialView.h"

static NSString *RadioDialtViewTitleNoChannelSelected = @"Pull down and slide left / right to select a channel";

static NSString *RadioDialtViewTitleChannelSelected = @"On air !";

static NSString *RadioDialtViewChannelNoChannelSelected = @"No channel selected";
static NSString *RadioDialtViewChannelChannelSelected = @"Listening to channel %d";

@interface RadioDialView ()
@property(nonatomic) UILabel *title;
@property(nonatomic) UILabel *channel;
@end

@implementation RadioDialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0xdd/255. green:0xd6/255. blue:0xcc/255. alpha:1.0];
        self.title = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 60, 100)];
            [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [label setTextColor:[UIColor colorWithRed:0xab/255. green:0xa1/255. blue:0x97/255. alpha:1]];
            [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:40]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setNumberOfLines:0];
            [label setAdjustsFontSizeToFitWidth:NO];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            label;
        });
        self.title.text = RadioDialtViewTitleNoChannelSelected;
        [self addSubview:self.title];
        self.channel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 60, 100)];
            [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [label setTextColor:[UIColor colorWithRed:0xab/255. green:0xa1/255. blue:0x97/255. alpha:1]];
            [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setNumberOfLines:0];
            [label setAdjustsFontSizeToFitWidth:NO];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            label;
        });
        [self addSubview:self.channel];
        self.channel.text = RadioDialtViewChannelNoChannelSelected;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)layoutSubviews
{
    [self.title sizeToFit];
    [self.channel sizeToFit];
    self.title.center = self.center;
    self.title.frame = ({
        CGRect frame = self.title.frame;
        frame.origin.y -= floorf(frame.size.height / 2);
        frame.origin.y += 100;
        frame.origin.y -= floorf(self.frame.size.height / 4);
        frame;
    });
    self.channel.center = self.center;
    self.channel.frame = ({
        CGRect frame = self.channel.frame;
        frame.origin.y += floorf(frame.size.height / 2);
        frame.origin.y += 140;
        frame.origin.y -= floorf(self.frame.size.height / 4);
        frame;
    });
}

#pragma mark - Radio dial delegate methods
- (void)radioDial:(UIView *)radioDial didSelectChannel:(NSInteger)radioChannel
{
    NSLog(@"channel selected is %d", radioChannel);
    self.title.text = RadioDialtViewTitleChannelSelected;
    self.channel.text = [NSString stringWithFormat:RadioDialtViewChannelChannelSelected, radioChannel];
    [self setNeedsLayout];
}

@end
