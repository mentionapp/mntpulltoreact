//
//  MentionViewController.m
//  ExampleCustomContent
//
//  Created by Guillaume Sempe on 28/05/2014.
//  Copyright (c) 2014 mention.com. All rights reserved.
//

#import "MentionViewController.h"

#import "PullToReact/PullToReact.h"

#import "MentionPullToReactView.h"

@interface MentionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic) MNTPullToReactControl *reactControl;
@property(nonatomic) NSArray *data;
@end

@implementation MentionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _data = @[@"Favorite", @"Archive", @"Trash", @"Irrelevant", @"Ban"];
    }
    return self;
}

- (void)loadView
{
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:MentionPullToReactViewNumberOfAction];
    self.reactControl.threshold = 90;
    self.reactControl.contentView = [[MentionPullToReactView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    [self.reactControl addTarget:self action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];
    self.tableView.reactControl = self.reactControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger action = [indexPath row] % [self.data count];
    [self doAction:action + 1];
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

#pragma mark - Private
- (void)doAction:(NSInteger)action
{
    [self.reactControl beginAction:action];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        usleep(1100 * 1000);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.reactControl endAction:action];
        });
    });
}

@end
