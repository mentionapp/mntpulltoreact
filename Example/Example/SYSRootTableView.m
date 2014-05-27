//
//  SYSRootTableView.m
//  Example
//
//  Created by Guillaume Sempe on 22/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import "SYSRootTableView.h"
#import "RootTableViewDelegateAndDataSource.h"

#import "PullToReact/PullToReact.h"

@interface SYSRootTableView ()
@property(nonatomic) RootTableViewDelegateAndDataSource *delegateAndDataSource;
@end

@implementation SYSRootTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        MNTPullToReactControl *reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:4];
        reactControl.backgroundColor = [UIColor redColor];
        [reactControl addTarget:self action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];
        self.reactControl = reactControl;

        _delegateAndDataSource = [[RootTableViewDelegateAndDataSource alloc] init];
        self.delegate = _delegateAndDataSource;
        self.dataSource = _delegateAndDataSource;
    }
    return self;
}

- (void)reaction:(id)sender
{
    MNTPullToReactControl *reactControl = (MNTPullToReactControl *)sender;
    NSLog(@"Doing action %ld", (long)reactControl.action);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [reactControl endAction:reactControl.action];
        });
    });
}

@end
