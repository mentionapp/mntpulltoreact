//
//  RadioDialPullToReactView.h
//  ExampleCustomContent
//
//  Created by Guillaume Sempe on 02/06/2014.
//  Copyright (c) 2014 mention.com. All rights reserved.
//

#import "PullToReact/MNTPullToReactView.h"

#define RadioDialPullToReactViewNumberOfChannel 32

@protocol RadioDialPullToReactViewDelegate <NSObject>

- (void)radioDial:(UIView *)radioDial didSelectChannel:(NSInteger)radioChannel;

@end

@interface RadioDialPullToReactView : MNTPullToReactView

@property(nonatomic, assign) id<RadioDialPullToReactViewDelegate> radioDialDelegate;
@end
