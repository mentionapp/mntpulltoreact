//
//  MNTFakeGestureRecognizer.m
//  mention
//
//  Created by Guillaume Sempé on 03/12/2013.
//  Copyright (c) 2013 syst.ms. All rights reserved.
//

#import "MNTFakeGestureRecognizer.h"

@interface MNTFakeGestureRecognizer()

@property(nonatomic,assign) CGPoint lastPoint;

@end

@implementation MNTFakeGestureRecognizer

- (void)reset {
    [super reset];
    self.lastPoint = CGPointZero;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    if ([touches count] != 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    self.state = UIGestureRecognizerStateBegan;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    if (UIGestureRecognizerStateFailed == self.state) {
        return;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
}

@end
