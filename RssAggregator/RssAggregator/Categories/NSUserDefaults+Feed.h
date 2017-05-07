//
//  NSUserDefaults+Feed.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 07/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;

@interface NSUserDefaults (Feed)

- (NSArray<Feed *> *)readFeeds;
- (void)rewriteFeeds:(NSArray<Feed *> *)feeds;

@end
