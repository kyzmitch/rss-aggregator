//
//  FeedsLocalDataSource.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "FeedsLocalDataSource.h"

static NSString * const kFeedsArrayKey = @"kFeedsArrayKey";

@interface FeedsLocalDataSource ()

@property (strong, nonatomic) NSMutableArray<NSString *> *array;

@end

@implementation FeedsLocalDataSource

@synthesize delegate;

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _array = [NSMutableArray new];
    
    return self;
}

+ (FeedsLocalDataSource *)hardcodedFeeds {
    FeedsLocalDataSource *collection = [FeedsLocalDataSource new];
    
    
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    NSArray *cachedFeeds = [standard arrayForKey:kFeedsArrayKey];
    if (cachedFeeds == nil) {
        // Several hardcoded resources
        [collection.array addObject:@"https://lenta.ru/rss/news"];
        [collection.array addObject:@"https://3dnews.ru/news/rss/"];
    }
    else {
        [collection.array addObjectsFromArray:cachedFeeds];
    }
    
    return collection;
}

- (NSArray<NSString *> *)fetch {
    NSArray *copiedFeeds = [[NSArray alloc] initWithArray:self.array copyItems:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate feedSourcesFetched:copiedFeeds];
    });
    
    return copiedFeeds;
}


- (NSString *)removeSourceAtIndex:(NSUInteger)index {
    if (index >= self.array.count) {
        return nil;
    }
    NSString *removedFeed = [self.array objectAtIndex:index];
    [self.array removeObjectAtIndex:index];
    [[NSUserDefaults standardUserDefaults] setObject:self.array forKey:kFeedsArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate feedDidRemove:removedFeed];
    });
    
    return removedFeed;
}

- (void)addSource:(NSString *)s {
    // Will hardcode that it is added alwasy first
    [self.array insertObject:s atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.array forKey:kFeedsArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate feedDidAdd:s];
    });
}

@end
