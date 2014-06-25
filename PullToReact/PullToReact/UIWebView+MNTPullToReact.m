//
//  UIWebView+MNTPullToReact.m
//  mention
//
//  Created by Guillaume Sempe on 24/06/2014.
//  Copyright (c) 2014 syst.ms. All rights reserved.
//

#import "UIWebView+MNTPullToReact.h"

#import <objc/runtime.h>

#import "MNTPullToReactControl+Private.h"

NSString * const kMNTPullToReactWebViewKey = @"kMNTPullToReactWebViewKey";

@implementation UIWebView (MNTPullToReact)

- (void)setReactControl:(MNTPullToReactControl *)reactControl
{
    MNTPullToReactControl *_reactControl = self.reactControl;
    [_reactControl removeFromWebView];
    objc_setAssociatedObject(self, &kMNTPullToReactWebViewKey, reactControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [reactControl reactFromWebView:self];
}

- (MNTPullToReactControl *)reactControl
{
    return (MNTPullToReactControl *)objc_getAssociatedObject(self, &kMNTPullToReactWebViewKey);
}

@end
