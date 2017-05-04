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
    [array addObject:@"https://lenta.ru/rss/articles"];
    [array addObject:@"https://news.yandex.ru/computers.rss"];
    return [[NSArray alloc] initWithArray:array copyItems:NO];
}

@end
