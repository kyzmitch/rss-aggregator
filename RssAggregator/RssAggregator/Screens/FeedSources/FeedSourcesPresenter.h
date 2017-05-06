//
//  FeedSourcesPresenter.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonViewInterface.h"

@protocol FeedSourcesView <CommonViewInterface>

@required
- (void)feedSourcesLoaded:(NSArray<NSString *> *)sources;
- (void)failedLoadFeedSources;
- (void)feedRemoved:(NSString *)feed atIndex:(NSUInteger)ix;
- (void)feedAdded:(NSString *)feedAddress;

@end

@protocol FeedSourcesPresenter <NSObject>

@required
- (void)loadFeedSources;
- (void)removeFeedSourceAtIndex:(NSUInteger)ix;
- (void)addFeed:(NSString *)feedAddress;

@end
