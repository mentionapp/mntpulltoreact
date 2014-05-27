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
        _delegateAndDataSource = [[RootTableViewDelegateAndDataSource alloc] init];
        self.delegate = _delegateAndDataSource;
        self.dataSource = _delegateAndDataSource;
        
        MNTPullToReactControl *reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:4];
        reactControl.backgroundColor = [UIColor redColor];
        [reactControl addTarget:_delegateAndDataSource action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];
        self.reactControl = reactControl;
    }
    return self;
}

@end
