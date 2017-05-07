//
//  AddFeedViewController.h
//  RssAggregator
//
//  Created by admin on 06/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "BaseViewController.h"

@class Feed;

@protocol FeedAddBackProtocol <NSObject>

- (void)feedDidCreate:(Feed *)feedAddress;
- (void)feedDidUpdate:(Feed *)feed withNewFeed:(Feed *)newFeed;

@end

@interface AddFeedViewController : BaseViewController

@property (weak, nonatomic) id<FeedAddBackProtocol> delegate;
@property (copy, nonatomic) Feed *feedForUpdate;

@end
