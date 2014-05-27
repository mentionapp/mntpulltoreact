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
    _data = @[@"redColor", @"greenColor", @"whiteColor"];
    return self;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Change react control according to the cell selected
    NSInteger index = [indexPath row] % [self.data count];
    MNTPullToReactControl *reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:4];
    if ([[_data objectAtIndex:index] isEqualToString:@"redColor"]) {
        reactControl.backgroundColor = [UIColor redColor];
    }
    if ([[_data objectAtIndex:index] isEqualToString:@"greenColor"]) {
        reactControl.backgroundColor = [UIColor greenColor];
    }
    if ([[_data objectAtIndex:index] isEqualToString:@"whiteColor"]) {
        reactControl.backgroundColor = [UIColor whiteColor];
    }
    [reactControl addTarget:tableView action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];

    tableView.reactControl = reactControl;
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

@end

