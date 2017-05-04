//
//  FeedsLocalDataSource.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "FeedsLocalDataSource.h"

@implementation FeedsLocalDataSource

- (NSArray<NSString *> *)fetch {
    NSMutableArray<NSString *> *array = [NSMutableArray new];
    
    return [[NSArray alloc] initWithArray:array copyItems:NO];
}

@end
