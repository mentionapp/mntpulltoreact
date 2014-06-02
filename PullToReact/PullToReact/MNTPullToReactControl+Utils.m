//
//  MNTPullToReactControl+Utils.m
//  PullToReact
//
//  Created by Guillaume Sempe on 02/06/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import "MNTPullToReactControl+Utils.h"

#import <objc/runtime.h>

#import "MNTPullToReactView.h"

@implementation MNTPullToReactControl (Utils)

- (BOOL)isContentViewOverridesMethod:(SEL)aSelector
{
    if (class_getMethodImplementation([self.contentView class], aSelector) !=
        class_getMethodImplementation([MNTPullToReactView class], aSelector)) {
        return YES;
    } else {
        return NO;
    }
}

@end
