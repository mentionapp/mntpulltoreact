MNTPullToReact
==============
MNTPullToReact is an extended evolution of the famous pull to refresh interaction. The main idea comes from a unique question: can the natural pulling gesture do more than just refresh and therefore avoid ugly action buttons that take up precious content space?

You can bind as many reactions as you'd like to MNTPullToReact and have your user access specific application actions through this unique and well known gesture.

MNTPullToReact is very easy to use and highly customizable.
- [Easy to use](#easy-to-use)
- [Highly customizable](#highly-customizable)


If you're using MNTPullToReact in your application, add your application link to the [application list](#applications).

I also want to thanks the contributors. If I forget, please add yourself to the [contributors list](#contributors). There is always something to do or improve, you can read the [todo list](#todo) if you search for a way to contribute

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

### Usage step by step
+ Add it to your project

If you use [CocoaPods](http://cocoapods.org/) add this line to your `Podfile` :
``` ruby
pod 'MNTPullToReact', '~> 1.0'
```
If you do not use CocoaPods the add all the needed files to your project and set the settings needed accordingly to the [podspec](https://github.com/mentionapp/mntpulltoreact/blob/master/MNTPullToReact.podspec) of the library. 
Notably, do not forget to add -ObjC to the other linker flags
```
OTHER_LDFLAGS -ObjC
```

+ In your view controller or your subclass import the library header
``` objective-c
#import "PullToReact.h"
```

+ Set to the new `reactControl` of the `UITableView` class the Pull to React you want to use
``` objective-c
MNTPullToReactControl *reactControl = [[MNTPullToReactControl alloc] initWithNumberOfActions:4];
reactControl.backgroundColor = [UIColor redColor];
[reactControl addTarget:_delegateAndDataSource action:@selector(reaction:) forControlEvents:UIControlEventValueChanged];
self.reactControl = reactControl;
```
+ Add to the target class the action method implementation
``` objective-c
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
```
Once your asynchronous task terminated, do not forget to call the `endAction:` method to inform the control Pull to React control.

## Highly customizable
You can customize your own pull to react features without any limits by subclassing the MNTPullToReactView class.
<p align="center" >
  <img src="https://raw.githubusercontent.com/mentionapp/mntpulltoreact/master/README/examples.jpg" alt="Pull to React examples" title="Pull to React examples">
</p>
To see how to make amazing Pull to React designs you can go through the [examples](https://github.com/mentionapp/mntpulltoreact/tree/master/ExampleCustomContent) provided in the library.
## Todo
- Improve and finish the documentation to get it added to http://cocoadocs.org/
- Add the possiblity to give a pull to react control to a `UIWebView`
- Add the possibility to put the pull to react control on other sides of the targeted view (on the left, on the right and at the bottom)

## Applications
If you are using MNTPullToReact in your application add your App Store link in the list here.

## Contributors
- [Alex Manthei](https://github.com/amanthei)
