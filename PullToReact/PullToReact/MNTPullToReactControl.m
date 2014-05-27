//
//  MNTPullToReactControl.m
//  PullToReact
//
//  Created by Guillaume Sempe on 26/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import "MNTPullToReactControl.h"

#import <pthread.h>

#import "MNTFakeGestureRecognizer.h"
#import "MNTPullToReactDefaultView.h"

#define MNTPullToReactControlDefaultThreshold 75.0f

#define MNTPullToReactControlComputePullHeight(l) ({ \
CGFloat referenceY = self.scrollView.contentInset.top; \
CGFloat currentY = self.scrollView.contentOffset.y; \
((-referenceY)-currentY)>=0.0?((-referenceY)-currentY):0.0; \
})

@interface MNTPullToReactControl ()<UIGestureRecognizerDelegate>
{
    pthread_mutex_t _actionMutex;
}
@property(nonatomic, assign) NSInteger action; // Store the current action triggered. O means no action triggered
@property(nonatomic, assign, readwrite) NSInteger numberOfActions;
@property(nonatomic, assign, readwrite) UIScrollView *scrollView;
@property(nonatomic) MNTFakeGestureRecognizer *fakeGestureRecognizer;
@end

@implementation MNTPullToReactControl

- (id)initWithFrame:(CGRect)frame
{
    return nil;
}

- (id)initWithNumberOfActions:(NSInteger)number
{
    MNTPullToReactView *contentView = [[MNTPullToReactDefaultView alloc] init];
    if (nil == contentView) {
        return nil;
    }
    self = [super initWithFrame:contentView.bounds];
    if (nil == self) {
        return nil;
    }
    self.action = 0;
    pthread_mutex_init(&_actionMutex, NULL);
    self.numberOfActions = number;
    self.contentView = contentView;
    self.threshold = MNTPullToReactControlDefaultThreshold;
    return self;
}

#pragma mark - Accessors
- (void)setContentView:(MNTPullToReactView *)contentView
{
    if (_contentView == contentView) {
        return;
    }
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self addSubview:_contentView];
}

#pragma mark - UIGestureRecognizer delegate protocol
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handleFakeGesture:(MNTFakeGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            [self handletouchBeganAtLocation:[gesture locationInView:self.scrollView]];
            break;
        case UIGestureRecognizerStateChanged:
            [self handletouchMoveToLocation:[gesture locationInView:self.scrollView]];
            break;
        case UIGestureRecognizerStateCancelled:
            [self handletouchAbortedAtLocation:[gesture locationInView:self.scrollView]];
            break;
        case UIGestureRecognizerStateFailed:
            [self handletouchAbortedAtLocation:[gesture locationInView:self.scrollView]];
            break;
        case UIGestureRecognizerStateEnded:
            [self handletouchEndedAtLocation:[gesture locationInView:self.scrollView]];
            break;
        default:
            break;
    }
    
}

- (void)handletouchBeganAtLocation:(CGPoint)location
{
    /*
     Override y position to activate pull only when scrollview is at the top
     */
    CGFloat y = MNTPullToReactControlComputePullHeight(location);
    CGPoint updatedLocation = {location.x, y};
    NSLog(@"point is %@", NSStringFromCGPoint(updatedLocation));
}

- (void)handletouchMoveToLocation:(CGPoint)location
{
    CGFloat y = MNTPullToReactControlComputePullHeight(location);
    CGPoint updatedLocation = {location.x, y};
    [self updateWithLocation:updatedLocation];
}

- (void)handletouchAbortedAtLocation:(CGPoint)location
{
    NSLog(@"%s", __func__);
}

- (void)handletouchEndedAtLocation:(CGPoint)location
{
    NSLog(@"%s", __func__);
    CGFloat y = MNTPullToReactControlComputePullHeight(location);
    CGPoint updatedLocation = {location.x, y};
    [self doWithLocation:updatedLocation];
}

- (void)updateWithLocation:(CGPoint)location
{
    if (location.y < self.threshold) {
        pthread_mutex_lock(&_actionMutex);
        if (0!=self.action) {
            self.action = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.contentView willTriggerAction:self.action];
                
                [self.contentView didTriggerAction:self.action];
            });
        }
        pthread_mutex_unlock(&_actionMutex);
    } else {
        pthread_mutex_lock(&_actionMutex);
        // find the action that should be triggered
        CGFloat actionWidth = floorf(self.scrollView.bounds.size.width / self.numberOfActions);
        int action = (int)floorf(location.x / actionWidth) + 1;
        if (action != self.action) {
            self.action = action;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.contentView willTriggerAction:self.action];
                
                [self.contentView didTriggerAction:self.action];
            });
        }
        pthread_mutex_unlock(&_actionMutex);
    }
}

- (void)doWithLocation:(CGPoint)location
{
    if (location.y >= self.threshold) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentView willDoAction:self.action];
            
            [self.contentView didDoAction:self.action];
        });
    }
}

@end

@implementation MNTPullToReactControl (Private)

- (void)reactFromScrollView:(UIScrollView *)scrollView
{
    self.frame = ({
        CGRect frame = self.frame;
        frame.origin.y = -frame.size.height;
        frame.size.width = scrollView.bounds.size.width;
        frame;
    });
    self.scrollView = scrollView;
    [scrollView addSubview:self];
    
    self.fakeGestureRecognizer = [[MNTFakeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFakeGesture:)];
    self.fakeGestureRecognizer.cancelsTouchesInView = NO;
    self.fakeGestureRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:self.fakeGestureRecognizer];
}

@end
