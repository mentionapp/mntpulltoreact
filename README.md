mntpulltoreact
==============
MNTPullToReact is a kind of extension of the famous interaction pull to refresh. The main idea comes from an unique question: Is that the natural pulling gesture can make more and so avoid ugly action buttons that take the precious place to the content.

You can bind as many reaction as you want to a MNTPullToReact and have your user access your application specific actions through an unique and well known gesture.

MNTPullToReact is very easy to use and highly customizable.

## Easy to use
The shortest sample code use the MNTPullToReactDefaultView. For instance the code below create a pull to react with 4 actions.

``` objective-c
#import "PullToReact/PullToReact.h"

- (void)viewDidLoad
{
   [super viewDidLoad];
   self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
   self.tableView.delegate = self;
   self.tableView.dataSource = self;
   MNTPullToReactControl *reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:4];
   reactControl.backgroundColor = [UIColor redColor];
   [reactControl addTarget:self action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];
   self.tableView.reactControl = reactControl;
}

#pragma mark - Pull to react target-action method
- (void)reaction:(id)sender
{
   MNTPullToReactControl *reactControl = (MNTPullToReactControl *)sender;
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      NSLog(@"Doing action %ld", (long)reactControl.action);
      usleep(1100 * 1000);
         dispatch_async(dispatch_get_main_queue(), ^{
            [reactControl endAction:reactControl.action];
         });
   });
}
```

## Highly customizable
You can customize your pull to react without any limit by subclassing the MNTPullToReactView class.

