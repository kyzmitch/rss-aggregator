//
//  NewsListPresenter.h
//  RssAggregator
//
//  Created by admin on 05/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonViewInterface.h"

@class Feed;

@protocol NewsListView <CommonViewInterface>

- (void)feedItemsLoaded:(NSMutableDictionary<Feed *, NSMutableArray *> *)itemsDictionary;
- (void)feedItemsLoaded:(NSMutableArray *)items forSource:(Feed *)sourceAddess;
- (void)feedItemsUpdated:(NSMutableArray *)items forSource:(Feed *)source;
- (void)feedRemoved:(Feed *)feed fromIndex:(NSUInteger)index;
- (void)feedTitleUpdated:(Feed *)feed forIndex:(NSUInteger)index;
- (void)failedLoadFeedItems;

@end

@protocol NewsListPresenter <NSObject>

- (void)fetchItemsForFeedSources:(NSArray<Feed *> *)sources;
- (void)fetchItemsForOneSource:(Feed *)source;
- (void)updateItemsForOldFeed:(Feed *)oldFeed withSource:(Feed *)feed;

@end
