//
//  RefreshViewController.m
//  ExampleCustomContent
//
//  Created by Guillaume Sempe on 04/06/2014.
//  Copyright (c) 2014 mention.com. All rights reserved.
//

#import "RefreshViewController.h"

#import "PullToReact/PullToReact.h"

#import "RefreshPullToReactView.h"

@interface RefreshViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) UITableView *tableView;
@property(nonatomic) MNTPullToReactControl *reactControl;
@property(nonatomic) NSArray *data;
@end

@implementation RefreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _data = @[@"An", @"example", @"of", @"pull to refresh", @"with MNTPullToReact", @"Enjoy !"];
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
    self.reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:RefreshPullToReactViewNumberOfChannel];
    self.reactControl.threshold = 90;
    self.reactControl.contentView = [[RefreshPullToReactView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.reactControl.threshold)];
    [self.reactControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
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
- (void)refresh:(id)sender
{
    MNTPullToReactControl *reactControl = (MNTPullToReactControl *)sender;
    NSLog(@"Refreshing...");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        usleep(1100 * 1000);
        dispatch_async(dispatch_get_main_queue(), ^{
            [reactControl endAction:reactControl.action];
        });
    });
}


@end
