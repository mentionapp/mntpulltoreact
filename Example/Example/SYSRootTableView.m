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
        self.reactControl = reactControl;

        _delegateAndDataSource = [[RootTableViewDelegateAndDataSource alloc] init];
        self.delegate = _delegateAndDataSource;
        self.dataSource = _delegateAndDataSource;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
