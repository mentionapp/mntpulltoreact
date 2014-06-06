//
//  MNTPullToReactDefaultView.m
//  PullToReact
//
//  Created by Guillaume Sempe on 27/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import "MNTPullToReactDefaultView.h"

static NSString *MNTPullToReactDefaultViewMsgNoAction = @"No action triggered";
static NSString *MNTPullToReactDefaultViewMsgActionTrigger = @"Action %d triggered";
static NSString *MNTPullToReactDefaultViewMsgDoingAction = @"Doing action %d";
static NSString *MNTPullToReactDefaultViewMsgHasDoneAction = @"Action %d done";

@interface MNTPullToReactDefaultView ()
@property(nonatomic) UILabel *actionLabel;
@end

@implementation MNTPullToReactDefaultView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0,
                                           0,
                                           [[UIScreen mainScreen] bounds].size.width,
                                           300 // Magic number choosen at random
                                           )];
    if (self) {
        [self commonInit];
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    _actionLabel = ({
        CGRect frame = self.bounds;
        frame.size.height = 60.0;
        frame.origin.y = self.bounds.size.height - frame.size.height;
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = MNTPullToReactDefaultViewMsgNoAction;
        label;
    });
    [self addSubview:_actionLabel];
}

- (void)didTriggerAction:(NSInteger)action
{
    if (0 == action) {
        self.actionLabel.text = MNTPullToReactDefaultViewMsgNoAction;
    } else {
        self.actionLabel.text = [NSString stringWithFormat:MNTPullToReactDefaultViewMsgActionTrigger, action];
    }
}

- (void)willDoAction:(NSInteger)action
{
    self.actionLabel.text = [NSString stringWithFormat:MNTPullToReactDefaultViewMsgDoingAction, action];
}

- (void)didDoAction:(NSInteger)action
{
    self.actionLabel.text = [NSString stringWithFormat:MNTPullToReactDefaultViewMsgHasDoneAction, action];
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
