//
//  NewsListPresenterImpl.h
//  RssAggregator
//
//  Created by admin on 05/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsListPresenter.h"

@interface NewsListPresenterImpl : NSObject <NewsListPresenter>

- (nullable instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithView:(nonnull id<NewsListView>)view NS_DESIGNATED_INITIALIZER;

@end
