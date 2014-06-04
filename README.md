MNTPullToReact
==============
MNTPullToReact is a kind of extension of the famous interaction pull to refresh. The main idea comes from an unique question: Is that the natural pulling gesture can make more and so avoid ugly action buttons that take the precious place to the content.

You can bind as many reaction as you want to a MNTPullToReact and have your user access your application specific actions through an unique and well known gesture.

MNTPullToReact is very easy to use and highly customizable.

## Easy to use
It is a subclass of an `UIControl` and embrace the common [target-action](https://developer.apple.com/library/ios/documentation/general/conceptual/Devpedia-CocoaApp/TargetAction.html) design pattern widely used in the Apple own controls. It mimics also the Apple `UIRefreshControl` control interface to facilitate its usage by developers who already use the Apple pull to refresh control.

| What                        | `UIRefreshControl`            | `MNTPullToReact`              |
| --------------------------- | ----------------------------- | ----------------------------- |
| Property to know the status | `BOOL refreshing`             | `NSInteger action`            |
| Initiate an action          | `beginRefreshing`             | `beginAction:`                |
| Terminate an action         | `endRefreshing`               | `endAction:`                  |
| Event on action needed      | `UIControlEventValueChanged ` | `UIControlEventValueChanged ` |

### Shortest code sample
The shortest code sample use the MNTPullToReactDefaultView. For instance the code below create a pull to react with 4 actions.

``` objective-c
// Import the library header
#import "PullToReact.h"

// In the viewDidLoad create the control
MNTPullToReactControl *reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:4];
[reactControl addTarget:self action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];
self.tableView.reactControl = reactControl;

// Than create the target-action method
- (void)reaction:(id)sender
{
    // Do the reaction thing
    [reactControl endAction:reactControl.action];
}
```

## Highly customizable
You can customize your pull to react without any limit by subclassing the MNTPullToReactView class.

