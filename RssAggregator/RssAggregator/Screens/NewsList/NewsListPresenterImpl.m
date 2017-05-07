//
//  NewsListPresenterImpl.m
//  RssAggregator
//
//  Created by admin on 05/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "NewsListPresenterImpl.h"
#import <MWFeedParser/MWFeedParser.h>
#import "NSString+Custom.h"
#import "Feed.h"

typedef NS_ENUM(NSUInteger, LoadingType) {
    ItemsLoadingForAddedSource,
    ItemsLoadingForUpdatedSource
};

@interface NewsListPresenterImpl () <MWFeedParserDelegate>

@property (weak, nonatomic) id<NewsListView> newsListView;
@property (strong, nonatomic) dispatch_queue_t fetchQueue;
@property (strong, nonatomic) dispatch_group_t group;
@property (strong, nonatomic) NSMutableDictionary<Feed *, NSMutableArray<MWFeedItem *> *> *rssItems;

@property (strong, nonatomic) Feed *addedSource;
@property (strong, nonatomic) Feed *updatedSource;
@property (strong, nonatomic) MWFeedParser *newlyAddedSourceFeedParser;
@property (strong, nonatomic) MWFeedParser *updatedSourceFeedParser;

@end

@implementation NewsListPresenterImpl

- (nullable instancetype)initWithView:(nonnull id<NewsListView>)view {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _newsListView = view;
    // Can't use concurrent queue for MWFeedParser :(
    // dispatch_apply called only for 1st index - one time
    
    // Most likely it's because following:
    // > MWFeedParser is not currently thread-safe.
    // Just found that, so, better to use some another RSS framework
    // to fully use power of dispatch_apply
    
    _fetchQueue = dispatch_queue_create([NSString bundleNameWithSuffix:@"rss.fetch"], DISPATCH_QUEUE_SERIAL);
    _rssItems = [NSMutableDictionary new];
    
    return self;
}

- (void)fetchItemsForFeedSources:(NSArray<Feed *> *)sources {
    [self.newsListView showProgress];
    self.group = dispatch_group_create();
    
    [self.rssItems removeAllObjects];
    [sources enumerateObjectsUsingBlock:^(Feed * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rssItems setObject:[NSMutableArray new] forKey:obj];
    }];
    
    __weak typeof(self) weakSelf = self;
    size_t amount = sources.count;
    dispatch_apply(amount, self.fetchQueue, ^(size_t ix) {
        typeof(self) self = weakSelf;
        
        if (self) {
            dispatch_group_enter(self.group);
            Feed *source = [sources objectAtIndex:ix];
            NSURL *feedURL = [NSURL URLWithString:source.address];
            MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
            feedParser.delegate = self;
            feedParser.feedParseType = ParseTypeFull;
            feedParser.connectionType = ConnectionTypeAsynchronously;
            [feedParser parse];
        }
    });
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        typeof(self) self = weakSelf;
        
        if (self) {
            NSMutableDictionary *items = [[NSMutableDictionary alloc] initWithDictionary:self.rssItems copyItems:NO];
            
            // Log
            NSArray *keys = [items allKeys];
            for (Feed *key in keys) {
                NSArray *articles = [items objectForKey:key];
                NSLog(@"%@: loaded %lu articles for feed %@", [self class], (unsigned long)articles.count, key.address);
            }
            
            typeof(self.newsListView) view = self.newsListView;
            dispatch_async(dispatch_get_main_queue(), ^{
                [view feedItemsLoaded:items];
                [view hideProgress];
            });
        }
    });
}


- (void)fetchItemsForOneSource:(Feed *)source {
    [self.newsListView showProgress];
    [self.rssItems setObject:[NSMutableArray new] forKey:source];
    
    // With that RSS framework I can't run it on background queue
    // only on main queue
    [self loadItemsForSource:source typeOfLoad:ItemsLoadingForAddedSource];

}

- (void)updateItemsForIndex:(NSUInteger)index withSource:(Feed *)feed {
    typeof(self.newsListView) view = self.newsListView;
    [view showProgress];
    NSArray *keys = [self.rssItems allKeys];
    Feed *key = [keys objectAtIndex:index];
    
    if ([key.address isEqualToString:feed.address]) {
        // just need to update title
        key.title = feed.title;
        [view feedTitleUpdated:key forIndex:index];
        [view hideProgress];
    }
    else {
        // clear
        [self.rssItems removeObjectForKey:key];
        [view feedRemoved:key fromIndex:index];
        
        // create new one
        [self.rssItems setObject:[NSMutableArray new] forKey:feed];
        [self loadItemsForSource:feed typeOfLoad:ItemsLoadingForUpdatedSource];
    }
}

- (void)loadItemsForSource:(Feed *)feed typeOfLoad:(LoadingType)type {
    NSURL *feedURL = [NSURL URLWithString:feed.address];
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull;
    feedParser.connectionType = ConnectionTypeAsynchronously;
    
    if (type == ItemsLoadingForAddedSource) {
        self.addedSource = feed;
        self.newlyAddedSourceFeedParser = feedParser;
    }
    else {
        self.updatedSource = feed;
        self.updatedSourceFeedParser = feedParser;
    }
    
    
    [feedParser parse];
}

#pragma mark - MWFeedParserDelegate

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSArray *keys = [self.rssItems allKeys];
    for (Feed *key in keys) {
        if ([key.address isEqualToString:parser.url.absoluteString]) {
            
            NSMutableArray *items = [self.rssItems objectForKey:key];
            [items addObject:item];
            break;
        }
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"%@: finished parsing source %@", [self class], parser.url.absoluteString);
    
    // Using state variables to check for which request this response belongs to
    // RSS framework doesn't support blocks, only delegate
    
    if (self.addedSource == nil && self.updatedSource == nil) {
        dispatch_group_leave(self.group);
    }
    else if (self.addedSource) {
        self.addedSource = nil;
        self.newlyAddedSourceFeedParser = nil;
        
        NSArray *keys = [self.rssItems allKeys];
        for (Feed *key in keys) {
            if ([key.address isEqualToString:parser.url.absoluteString]) {
                
                NSMutableArray *items = [self.rssItems objectForKey:key];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.newsListView hideProgress];
                    [self.newsListView feedItemsLoaded:items forSource:key];
                });
                break;
            }
        }
    }
    else if (self.updatedSource) {
        self.updatedSource = nil;
        self.updatedSourceFeedParser = nil;
        
        NSArray *keys = [self.rssItems allKeys];
        for (Feed *key in keys) {
            if ([key.address isEqualToString:parser.url.absoluteString]) {
                
                NSMutableArray *items = [self.rssItems objectForKey:key];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.newsListView hideProgress];
                    [self.newsListView feedItemsUpdated:items forSource:key];
                });
                break;
            }
        }
    }
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"%@: failed to parse feed %@ with error %@", [self class], parser.url.absoluteString, [error description]);
    
    if (self.addedSource == nil && self.updatedSource == nil) {
        dispatch_group_leave(self.group);
    }
    else if (self.addedSource) {
        self.addedSource = nil;
        self.newlyAddedSourceFeedParser = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newsListView hideProgress];
            
            // Need to add at least empty section to table
            NSArray *keys = [self.rssItems allKeys];
            for (Feed *key in keys) {
                if ([key.address isEqualToString:parser.url.absoluteString]) {
                    
                    NSMutableArray *items = [self.rssItems objectForKey:key];
                    [self.newsListView feedItemsLoaded:items forSource:key];
                    break;
                }
            }
            
        });
        
    }
    else if (self.updatedSource) {
        self.updatedSource = nil;
        self.updatedSourceFeedParser = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newsListView hideProgress];
        });
    }
}

@end
