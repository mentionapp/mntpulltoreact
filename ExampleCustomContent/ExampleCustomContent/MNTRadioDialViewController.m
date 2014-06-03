//
//  MNTRadioDialViewController.m
//  ExampleCustomContent
//
//  Created by Guillaume Sempe on 02/06/2014.
//  Copyright (c) 2014 mention.com. All rights reserved.
//

#import "MNTRadioDialViewController.h"

#import "PullToReact/PullToReact.h"

#import "RadioDialPullToReactView.h"
#import "RadioDialView.h"

@interface MNTRadioDialViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic) RadioDialView *radioDialView;
@property(nonatomic) MNTPullToReactControl *reactControl;
@end

@implementation MNTRadioDialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.radioDialView = [[RadioDialView alloc] initWithFrame:self.view.bounds];
    self.tableView.tableFooterView = self.radioDialView;
    
    self.reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:RadioDialPullToReactViewNumberOfChannel];
    self.reactControl.threshold = 50;
    RadioDialPullToReactView *pullToReactView = [[RadioDialPullToReactView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    pullToReactView.radioDialDelegate = self.radioDialView;
    self.reactControl.contentView = pullToReactView;
    [self.reactControl addTarget:self action:@selector(dial:) forControlEvents:UIControlEventValueChanged];
    self.tableView.reactControl = self.reactControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil==cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
    return cell;
}

#pragma mark - Pull to react target-action method
- (void)dial:(id)sender
{
    MNTPullToReactControl *reactControl = (MNTPullToReactControl *)sender;
    NSLog(@"Dialing %ld", (long)reactControl.action);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        usleep(1100 * 1000);
        dispatch_async(dispatch_get_main_queue(), ^{
            [reactControl endAction:reactControl.action];
        });
    });
}

@end
