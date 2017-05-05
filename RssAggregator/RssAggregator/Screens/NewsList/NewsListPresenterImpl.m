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

@interface NewsListPresenterImpl () <MWFeedParserDelegate>

@property (weak, nonatomic) id<NewsListView> newsListView;
@property (strong, nonatomic) dispatch_queue_t fetchQueue;
@property (strong, nonatomic) dispatch_group_t group;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray<MWFeedItem *> *> *rssItems;

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

- (void)fetchItemsForFeedSources:(NSArray<NSString *> *)sources {
    [self.newsListView showProgress];
    self.group = dispatch_group_create();
    
    [self.rssItems removeAllObjects];
    [sources enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rssItems setObject:[NSMutableArray new] forKey:obj];
    }];
    
    __weak typeof(self) weakSelf = self;
    size_t amount = sources.count;
    dispatch_apply(amount, self.fetchQueue, ^(size_t ix) {
        typeof(self) self = weakSelf;
        
        if (self) {
            dispatch_group_enter(self.group);
            NSString *source = [sources objectAtIndex:ix];
            NSURL *feedURL = [NSURL URLWithString:source];
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
            typeof(self.newsListView) view = self.newsListView;
            [view feedItemsLoaded:items];
            [view hideProgress];
        }
    });
}

#pragma mark - MWFeedParserDelegate

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSMutableArray *items = [self.rssItems objectForKey:parser.url.absoluteString];
    [items addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    dispatch_group_leave(self.group);
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    dispatch_group_leave(self.group);
}

@end
