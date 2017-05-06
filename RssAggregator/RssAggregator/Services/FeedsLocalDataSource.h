//
//  FeedsLocalDataSource.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedDataSourceInterface.h"

@interface FeedsLocalDataSource : NSObject <FeedDataSourceInterface>

+ (FeedsLocalDataSource *)hardcodedFeeds;

@end
