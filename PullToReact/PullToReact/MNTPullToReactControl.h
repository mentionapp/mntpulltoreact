//
//  MNTPullToReactControl.h
//  PullToReact
//
//  Created by Guillaume Sempe on 26/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNTPullToReactView;

/**
 Events of the pull to react control
 
 UIControlEventValueChanged event is used to multicast any change of the pull to react
 
 */

@interface MNTPullToReactControl : UIControl

/**
 initWithNumberOfActions: initialize the pull to react with number of actions
 
 A default contentView is set while the contentView is not set by the user library
 
 @see contentView
 */
- (id)initWithNumberOfActions:(NSInteger)number;

/**
 contentView The content view of the pull to react
 
 Embed all the pull to react user interface and react to the events of the control
 */
@property(nonatomic) MNTPullToReactView *contentView;

/**
 An integer value indicating whether a action operation has been triggered and is in progress.
 
 O means no action in progress
 */
@property(nonatomic, assign, readonly) NSInteger action;

/**
 numberOfActions The number of actions that the pull to react control can trigger
 
 This property is set by the default init method initWithNumberOfActions:
 
 @see initWithNumberOfActions:
 */
@property(nonatomic, assign, readonly) NSInteger numberOfActions;

/**
 threshold The pull height after which actions are triggered
 
 @default 75.0
 */
@property(nonatomic, assign) CGFloat threshold;

/**
 scrollView The scrollview targeted
 
 This property is set when the Pull To React controller is set to a `reactControl` property of a scrollview
 
 @see [UITableView+MNTPullToReact reactControl]
 */
@property(nonatomic, assign, readonly) UIScrollView *scrollView;

/**
 Tells the control that an action operation was started programmatically.
 */
- (void)beginAction:(NSInteger)action;

/**
 Tells the control that an action has ended.
 */
- (void)endAction:(NSInteger)action;

@end
