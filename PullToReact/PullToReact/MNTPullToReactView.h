//
//  MNTPullToReactView.h
//  PullToReact
//
//  Created by Guillaume Sempe on 27/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNTPullToReactView : UIView

/**
 Notifies the pull to react view that its targeted scrollview is about to trigger an action.
 */
- (void)willTriggerAction:(NSInteger)action;

/**
 The targetted scrollview has triggered an action
 */
- (void)didTriggerAction:(NSInteger)action;

/**
 Notifies the pull to react view that its targeted scrollview is about to do an action.
 */
- (void)willDoAction:(NSInteger)action;

/**
 The targetted scrollview has done an action
 */
- (void)didDoAction:(NSInteger)action;

/**
 Notifies the pull to react that user moves its finger around the targeted scrollview
 */
- (void)didMoveTo:(CGPoint)point;

@end
