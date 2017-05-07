//
//  NSUserDefaults+Feed.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 07/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "NSUserDefaults+Feed.h"

static NSString * const kFeedsArrayKey = @"kFeedsArrayKey";

@implementation NSUserDefaults (Feed)

- (NSArray<Feed *> *)readFeeds {
    NSArray *cachedFeeds;
    id data = [self objectForKey:kFeedsArrayKey];
    if (data && [data isKindOfClass:[NSData class]]) {
        cachedFeeds = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return cachedFeeds;
}

- (void)rewriteFeeds:(NSArray<Feed *> *)feeds {
    if (feeds == nil || feeds.count == 0) {
        [self setObject:nil forKey:kFeedsArrayKey];
    }
    else {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:feeds];
        [self setObject:data forKey:kFeedsArrayKey];
    }
    
    [self synchronize];
}

@end
