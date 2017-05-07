//
//  FeedSourcesPresenter.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonViewInterface.h"

@class Feed;

@protocol FeedSourcesView <CommonViewInterface>

@required
- (void)feedSourcesLoaded:(NSArray<Feed *> *)sources;
- (void)failedLoadFeedSources;
- (void)feedRemoved:(Feed *)feed atIndex:(NSUInteger)ix;
- (void)feedAdded:(Feed *)feedAddress;
- (void)feedUpdated:(Feed *)feed atIndex:(NSUInteger)ix;

@end

@protocol FeedSourcesPresenter <NSObject>

@required
- (void)loadFeedSources;
- (void)removeFeedSourceAtIndex:(NSUInteger)ix;
- (void)addFeed:(Feed *)feedAddress;
- (void)updateFeed:(Feed *)feed withNewFeed:(Feed *)newFeed;

@end
