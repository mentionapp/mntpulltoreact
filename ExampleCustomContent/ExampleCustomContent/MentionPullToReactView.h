//
//  MentionPullToReactView.h
//  ExampleCustomContent
//
//  Created by Guillaume Sempe on 28/05/2014.
//  Copyright (c) 2014 mention.com. All rights reserved.
//

#import "PullToReact/MNTPullToReactView.h"

#define MentionPullToReactViewNumberOfAction 5

typedef NS_ENUM(NSInteger, MNTMentionHeaderActions)
{
    mntMentionHeaderActionFavorite = 0,
    mntMentionHeaderActionArchive = 1,
    mntMentionHeaderActionTrash = 2,
    mntMentionHeaderActionIrrelevant = 3,
    mntMentionHeaderActionBan = 4
};

@interface MentionPullToReactView : MNTPullToReactView

@end
