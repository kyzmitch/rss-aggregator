//
//  NewsListPresenter.h
//  RssAggregator
//
//  Created by admin on 05/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonViewInterface.h"

@protocol NewsListView <CommonViewInterface>

- (void)feedItemsLoaded:(NSMutableDictionary<NSString *, NSMutableArray *> *)itemsDictionary;
- (void)failedLoadFeedItems;

@end

@protocol NewsListPresenter <NSObject>

- (void)fetchItemsForFeedSources:(NSArray<NSString *> *)sources;

@end
