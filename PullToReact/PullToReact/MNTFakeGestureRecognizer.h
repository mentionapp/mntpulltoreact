//
//  MNTFakeGestureRecognizer.h
//  mention
//
//  Created by Guillaume Sempé on 03/12/2013.
//  Copyright (c) 2013 syst.ms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MNTFakeGestureRecognizer : UIGestureRecognizer

- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
