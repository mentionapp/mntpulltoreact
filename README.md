MNTPullToReact
==============
MNTPullToReact is an extended evolution of the famous pull to refresh interaction. The main idea comes from a unique question: can the natural pulling gesture do more than just refresh and therefore avoid ugly action buttons that take up precious content space?

You can bind as many reactions as you'd like to MNTPullToReact and have your user access specific application actions through this unique and well known gesture.

MNTPullToReact is very easy to use and highly customizable.
- [Easy to use](#easy-to-use)
- [Highly customizable](#highly-customizable)

## Demo

<p align="center" >
  <img src="https://raw.githubusercontent.com/mentionapp/mntpulltoreact/master/README/mention-example.gif" alt="Pull to React demo" title="Pull to React demo">
</p>

## Easy to use
MNTPullToReact is a subclass of `UIControl` and embraces the common [target-action](https://developer.apple.com/library/ios/documentation/general/conceptual/Devpedia-CocoaApp/TargetAction.html) design pattern widely used in Apple's own controls. It also mimics the Apple `UIRefreshControl` control interface to facilitate its usage by developers already familiar with the Apple pull to refresh control.

| What                        | `UIRefreshControl`            | `MNTPullToReact`              |
| --------------------------- | ----------------------------- | ----------------------------- |
| Property to know the status | `BOOL refreshing`             | `NSInteger action`            |
| Initiate an action          | `beginRefreshing`             | `beginAction:`                |
| Terminate an action         | `endRefreshing`               | `endAction:`                  |
| Event on action needed      | `UIControlEventValueChanged ` | `UIControlEventValueChanged ` |

### Short code sample
Here is a short code sample that uses the MNTPullToReactDefaultView under the hood. The following code creates a pull to react with 4 actions.

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
You can customize your own pull to react features without any limits by subclassing the MNTPullToReactView class.
<p align="center" >
  <img src="https://raw.githubusercontent.com/mentionapp/mntpulltoreact/master/README/examples.jpg" alt="Pull to React examples" title="Pull to React examples">
</p>

