//
//  SYSRootViewController.m
//  Example
//
//  Created by Guillaume Sempe on 22/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import "SYSRootViewController.h"
#import "SYSRootTableView.h"

@interface SYSRootViewController ()

@property(nonatomic) SYSRootTableView *tableView;
@end

@implementation SYSRootViewController

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
    SYSRootTableView *tableView = [[SYSRootTableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
