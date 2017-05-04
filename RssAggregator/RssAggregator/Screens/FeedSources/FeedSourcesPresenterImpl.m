//
//  FeedSourcesPresenterImpl.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "FeedSourcesPresenterImpl.h"

@interface FeedSourcesPresenterImpl ()

@property (weak, nonatomic) id<FeedSourcesView> feedSourcesView;
@property (strong, nonatomic) id<FeedDataSourceInterface> feedsDataSource;

@end

@implementation FeedSourcesPresenterImpl

- (nullable instancetype)initWithView:(nonnull id<FeedSourcesView>)view source:(nonnull id<FeedDataSourceInterface>)source {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _feedSourcesView = view;
    _feedsDataSource = source;
    
    return self;
}

- (void)loadFeedSources {
    [self.feedSourcesView showProgress];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray<NSString *> *sources = [self.feedsDataSource fetch];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.feedSourcesView feedSourcesLoaded:sources];
            [self.feedSourcesView hideProgress];
        });
    });
}

@end