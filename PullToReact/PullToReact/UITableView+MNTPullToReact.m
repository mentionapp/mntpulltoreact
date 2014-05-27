//
//  UITableView+MNTPullToReact.m
//  PullToReact
//
//  Created by Guillaume Sempe on 26/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import "UITableView+MNTPullToReact.h"

#import <objc/runtime.h>

#import "MNTPullToReactControl+Private.h"

NSString * const kMNTPullToReactKey = @"kMNTPullToReactKey";

@implementation UITableView (MNTPullToReact)

- (void)setReactControl:(MNTPullToReactControl *)reactControl
{
    MNTPullToReactControl *_reactControl = self.reactControl;
    [_reactControl removeFromScrollView];
    objc_setAssociatedObject(self, &kMNTPullToReactKey, reactControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [reactControl reactFromScrollView:self];
}

- (MNTPullToReactControl *)reactControl
{
    return (MNTPullToReactControl *)objc_getAssociatedObject(self, &kMNTPullToReactKey);
}

@end
