//
//  FeedsLocalDataSource.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "FeedsLocalDataSource.h"

@implementation FeedsLocalDataSource

@synthesize delegate;

- (NSArray<NSString *> *)fetch {
    NSMutableArray<NSString *> *array = [NSMutableArray new];
    
    // Several hardcoded resources (nsuserdefaults could be used or some another local storage)
    [array addObject:@"https://lenta.ru/rss/news"];
    [array addObject:@"http://www.opennet.ru/opennews/opennews_6_noadv.rss"];
    [array addObject:@"https://3dnews.ru/news/rss/"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate feedSourcesFetched:array];
    });
    
    return [[NSArray alloc] initWithArray:array copyItems:NO];
}

@end
