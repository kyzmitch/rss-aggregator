//
//  FeedsLocalDataSource.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "FeedsLocalDataSource.h"
#import "Feed.h"
#import "NSUserDefaults+Feed.h"

@interface FeedsLocalDataSource ()

@property (strong, nonatomic) NSMutableArray<Feed *> *array;

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
    
    NSArray<Feed *> *cachedFeeds = [[NSUserDefaults standardUserDefaults] readFeeds];
    if (cachedFeeds == nil) {
        // Several hardcoded resources
        Feed *lentaFeed = [Feed new];
        lentaFeed.title = @"Lenta news";
        lentaFeed.address = @"https://lenta.ru/rss/news";
        [collection.array addObject:lentaFeed];
        
        
        Feed *secondFeed = [Feed new];
        secondFeed.title = @"3D news";
        secondFeed.address = @"https://3dnews.ru/news/rss/";
        [collection.array addObject:secondFeed];
    }
    else {
        [collection.array addObjectsFromArray:cachedFeeds];
    }
    
    return collection;
}

- (NSArray<Feed *> *)fetch {
    NSArray *copiedFeeds = [[NSArray alloc] initWithArray:self.array copyItems:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate feedSourcesFetched:copiedFeeds];
    });
    
    return copiedFeeds;
}

- (Feed *)removeSourceAtIndex:(NSUInteger)index {
    if (index >= self.array.count) {
        return nil;
    }
    Feed *removedFeed = [self.array objectAtIndex:index];
    [self.array removeObjectAtIndex:index];
    
    [[NSUserDefaults standardUserDefaults] rewriteFeeds:self.array];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate feedDidRemove:removedFeed];
    });
    
    return removedFeed;
}

- (void)addSource:(Feed *)s {
    // Will hardcode that it is added alwasy first
    [self.array insertObject:s atIndex:0];
    [[NSUserDefaults standardUserDefaults] rewriteFeeds:self.array];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate feedDidAdd:s];
    });
}

- (NSUInteger)updateSource:(Feed *)s withNewSource:(Feed *)newSource {
    NSUInteger ix = [self.array indexOfObject:s];
    if (ix == NSNotFound) {
        return NSNotFound;
    }
    
    [self.array replaceObjectAtIndex:ix withObject:newSource];
    [[NSUserDefaults standardUserDefaults] rewriteFeeds:self.array];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate feedDidUpdated:s withSource:newSource];
    });
    
    return ix;
}

@end
