//
//  FeedSourcesPresenterImpl.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedSourcesPresenter.h"
#import "FeedDataSourceInterface.h"

@interface FeedSourcesPresenterImpl : NSObject <FeedSourcesPresenter>

- (nullable instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithView:(nonnull id<FeedSourcesView>)view source:(nonnull id<FeedDataSourceInterface>)source NS_DESIGNATED_INITIALIZER;

@end
