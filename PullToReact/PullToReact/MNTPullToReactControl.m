//
//  MNTPullToReactControl.m
//  PullToReact
//
//  Created by Guillaume Sempe on 26/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import "MNTPullToReactControl.h"

#import <pthread.h>

#import "MNTPullToReactControl+Utils.h"
#import "MNTFakeGestureRecognizer.h"
#import "MNTPullToReactDefaultView.h"

#define MNTPullToReactControlDefaultThreshold 75.0f

#define MNTPullToReactControlComputePullHeight(l) ({ \
CGFloat referenceY = self.scrollView.contentInset.top; \
CGFloat currentY = self.scrollView.contentOffset.y; \
((-referenceY)-currentY)>=0.0?((-referenceY)-currentY):0.0; \
})

#pragma mark - Pull to react private extension
@interface MNTPullToReactControl ()<UIGestureRecognizerDelegate>
{
    pthread_mutex_t _actionMutex;
    
    /**
     Memorize if the contentView overrides the methods
     */
    struct
    {
        unsigned int contentViewWillTriggerAction:1;
        unsigned int contentViewDidTriggerAction:1;
        unsigned int contentViewWillDoAction:1;
        unsigned int contentViewDidDoAction:1;
        unsigned int contentViewDidMoveTo:1;
    } contentViewFlags;
}
@property(nonatomic, assign, readwrite) NSInteger action;
@property(nonatomic, assign) NSInteger triggeredAction; // Memorize which action should be done on user launch
@property(nonatomic, assign) CGPoint location; // Memorize the location point of user finger
@property(nonatomic, assign, readwrite) NSInteger numberOfActions;
@property(nonatomic, assign, readwrite) UIScrollView *scrollView;

@property(nonatomic, assign, getter = isExpanded) BOOL expanded;
@property(nonatomic) MNTFakeGestureRecognizer *fakeGestureRecognizer; // Use to track user touch on the scrollview

@property(nonatomic, assign) UIEdgeInsets scrollViewContentInset; // Default scrollview content inset
@end

#pragma mark - Pull to react implementation
@implementation MNTPullToReactControl

#pragma mark Init methods
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
    _action = 0;
    _triggeredAction = 0;
    _location = CGPointZero;
    pthread_mutex_init(&_actionMutex, NULL);
    _numberOfActions = number;
    self.contentView = contentView; // set via the accessor to add the contentView to the hierarchy
    _threshold = MNTPullToReactControlDefaultThreshold;
    _expanded = NO;
    return self;
}

#pragma mark life cycle methods
- (void)beginAction:(NSInteger)action
{
    if (self.triggeredAction != action) {
        self.triggeredAction = action;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self contentViewWillTriggerAction];
            [self contentViewDidTriggerAction];
        });
    }
    self.scrollViewContentInset = self.scrollView.contentInset;
    self.action = action;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.expanded = YES;
        }];
        [self contentViewWillDoAction];
    });
}

- (void)endAction:(NSInteger)action
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self contentViewDidDoAction];
        self.action = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.expanded = NO;
        } completion:^(BOOL finished) {
            self.triggeredAction = 0;
            [self contentViewWillTriggerAction];
            [self contentViewDidTriggerAction];
        }];
    });
}

#pragma mark Accessors
- (void)setContentView:(MNTPullToReactView *)contentView
{
    if (_contentView == contentView) {
        return;
    }
    [_contentView removeFromSuperview];
    _contentView = contentView;
    contentViewFlags.contentViewWillTriggerAction = [self isContentViewOverridesMethod:@selector(willTriggerAction:)];
    contentViewFlags.contentViewDidTriggerAction = [self isContentViewOverridesMethod:@selector(didTriggerAction:)];
    contentViewFlags.contentViewWillDoAction = [self isContentViewOverridesMethod:@selector(willDoAction:)];
    contentViewFlags.contentViewDidDoAction = [self isContentViewOverridesMethod:@selector(didDoAction:)];
    contentViewFlags.contentViewDidMoveTo = [self isContentViewOverridesMethod:@selector(didMoveTo:)];
    [self addSubview:_contentView];
    self.frame = ({
        CGRect frame = _contentView.bounds;
        frame.origin.y = -frame.size.height;
        frame.size.width = self.scrollView.bounds.size.width;
        frame;
    });

}

- (void)setExpanded:(BOOL)expanded
{
    _expanded = expanded;
    if (expanded) {
        [self updateScrollViewContentTopInset:self.threshold];
    } else {
        [self updateScrollViewContentTopInset:0.0];
    }
}

#pragma mark Private
- (void)updateScrollViewContentTopInset:(CGFloat)topInset
{
    UIEdgeInsets inset = self.scrollViewContentInset;
	inset.top += topInset;
	if (UIEdgeInsetsEqualToEdgeInsets(self.scrollView.contentInset, inset)) {
		return;
	}
    self.scrollView.contentInset = inset;
    if (self.scrollView.contentOffset.y <= 0.0f) {
		[self.scrollView scrollRectToVisible:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) animated:NO];
	}
}

#pragma mark Content view actions
- (void)contentViewWillTriggerAction
{
    if (contentViewFlags.contentViewWillTriggerAction) {
        [self.contentView willTriggerAction:self.triggeredAction];
    }
}

- (void)contentViewDidTriggerAction
{
    if (contentViewFlags.contentViewDidTriggerAction) {
        [self.contentView didTriggerAction:self.triggeredAction];
    }
}

- (void)contentViewWillDoAction
{
    if (contentViewFlags.contentViewWillDoAction) {
        [self.contentView willDoAction:self.action];
    }
}

- (void)contentViewDidDoAction
{
    if (contentViewFlags.contentViewDidDoAction) {
        [self.contentView didDoAction:self.action];
    }
}

- (void)contentViewDidMoveTo
{
    if (contentViewFlags.contentViewDidMoveTo) {
        [self .contentView didMoveTo:self.location];
    }
}

#pragma mark UIGestureRecognizer delegate protocol
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark Gesture handling
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
    __unused CGPoint updatedLocation = {location.x, y};
}

- (void)handletouchMoveToLocation:(CGPoint)location
{
    CGFloat y = MNTPullToReactControlComputePullHeight(location);
    CGPoint updatedLocation = {location.x, y};
    [self updateWithLocation:updatedLocation];
}

- (void)handletouchAbortedAtLocation:(CGPoint)location
{
    // Nothing here right now
}

- (void)handletouchEndedAtLocation:(CGPoint)location
{
    CGFloat y = MNTPullToReactControlComputePullHeight(location);
    CGPoint updatedLocation = {location.x, y};
    [self doWithLocation:updatedLocation];
}

- (void)updateWithLocation:(CGPoint)location
{
    self.location = location;
    if (location.y < self.threshold) {
        pthread_mutex_lock(&_actionMutex);
        if (0!=self.triggeredAction) {
            self.triggeredAction = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self contentViewWillTriggerAction];
                
                [self contentViewDidTriggerAction];
            });
        }
        pthread_mutex_unlock(&_actionMutex);
    } else {
        pthread_mutex_lock(&_actionMutex);
        // find the action that should be triggered
        CGFloat actionWidth = floorf(self.scrollView.bounds.size.width / self.numberOfActions);
        int triggeredAction = (int)floorf(location.x / actionWidth) + 1;
        if (triggeredAction != self.triggeredAction) {
            self.triggeredAction = triggeredAction;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self contentViewWillTriggerAction];
                
                [self contentViewDidTriggerAction];
            });
        }
        pthread_mutex_unlock(&_actionMutex);
    }
    if (0 < location.y) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self contentViewDidMoveTo];
        });
    }
}

- (void)doWithLocation:(CGPoint)location
{
    if (location.y >= self.threshold) {
        [self beginAction:self.triggeredAction];
        self.triggeredAction = 0;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end

#pragma mark - Pull to react private category
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
    self.scrollViewContentInset = scrollView.contentInset;
    [scrollView addSubview:self];
    
    self.fakeGestureRecognizer = [[MNTFakeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFakeGesture:)];
    self.fakeGestureRecognizer.cancelsTouchesInView = NO;
    self.fakeGestureRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:self.fakeGestureRecognizer];
}

- (void)removeFromScrollView
{
    [self.scrollView removeGestureRecognizer:self.fakeGestureRecognizer];
    self.fakeGestureRecognizer.delegate = nil;
    self.scrollViewContentInset = UIEdgeInsetsZero;
    self.scrollView = nil;
}

@end
