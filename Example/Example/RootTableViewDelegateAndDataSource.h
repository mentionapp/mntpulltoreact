//
//  RootTableViewDelegateAndDataSource.h
//  Example
//
//  Created by Guillaume Sempe on 26/05/2014.
//  Copyright (c) 2014 syst-ms.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootTableViewDelegateAndDataSource : NSObject<UITableViewDelegate, UITableViewDataSource>

- (void)reaction:(id)sender; // reaction of the pull to react
@end
