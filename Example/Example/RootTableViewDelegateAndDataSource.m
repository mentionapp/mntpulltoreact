//
//  RootTableViewDelegateAndDataSource.m
//  Example
//
//  Created by Guillaume Sempe on 26/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import "RootTableViewDelegateAndDataSource.h"

#import "PullToReact/PullToReact.h"

@interface RootTableViewDelegateAndDataSource ()
@property(nonatomic) NSArray *data;
@end

@implementation RootTableViewDelegateAndDataSource

- (id)init
{
    self = [super init];
    if (nil == self) {
        return nil;
    }
    _data = @[@"redColor", @"greenColor", @"whiteColor", @"Reaction 1"];
    return self;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Change react control according to the cell selected
    NSInteger index = [indexPath row] % [self.data count];
    if ([[_data objectAtIndex:index] isEqualToString:@"redColor"]) {
        MNTPullToReactControl *reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:4];
        reactControl.backgroundColor = [UIColor redColor];
        [reactControl addTarget:self action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];
        tableView.reactControl = reactControl;
    }
    if ([[_data objectAtIndex:index] isEqualToString:@"greenColor"]) {
        MNTPullToReactControl *reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:4];
        reactControl.backgroundColor = [UIColor greenColor];
        [reactControl addTarget:self action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];
        tableView.reactControl = reactControl;
    }
    if ([[_data objectAtIndex:index] isEqualToString:@"whiteColor"]) {
        MNTPullToReactControl *reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:4];
        reactControl.backgroundColor = [UIColor whiteColor];
        [reactControl addTarget:self action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];
        tableView.reactControl = reactControl;
    }
    if ([[_data objectAtIndex:index] isEqualToString:@"Reaction 1"]) {
        [tableView.reactControl beginAction:1];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            usleep(1100 * 1000);
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView.reactControl endAction:tableView.reactControl.action];
            });
        });
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count] * 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil==cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    NSInteger index = [indexPath row] % [self.data count];
    cell.textLabel.text = [self.data objectAtIndex:index];
    return cell;
}

#pragma mark - Pull to react target-action method
- (void)reaction:(id)sender
{
    MNTPullToReactControl *reactControl = (MNTPullToReactControl *)sender;
    NSLog(@"Doing action %ld", (long)reactControl.action);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        usleep(1100 * 1000);
        dispatch_async(dispatch_get_main_queue(), ^{
            [reactControl endAction:reactControl.action];
        });
    });
}

@end

