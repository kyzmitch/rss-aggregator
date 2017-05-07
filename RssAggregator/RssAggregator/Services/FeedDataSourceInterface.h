//
//  FeedDataSourceInterface.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;

@protocol FeedsDelegate <NSObject>

@required
- (void)feedSourcesFetched:(NSArray<Feed *> *)sources;
@optional
- (void)feedDidAdd:(Feed *)value;
- (void)feedDidRemove:(Feed *)feed;
- (void)feedDidUpdatedAtIndex:(NSUInteger)index withSource:(Feed *)source;

@end

@protocol FeedDataSourceInterface <NSObject>

@required
- (NSArray<Feed *> *)fetch;
@property (weak, nonatomic) id<FeedsDelegate> delegate;

@optional
- (void)addSource:(Feed *)s;
- (Feed *)removeSourceAtIndex:(NSUInteger)index;
- (void)updateSourceAtIndex:(NSUInteger)index withSource:(Feed *)s;

@end

@protocol FeedInjectable <NSObject>

@required
- (void)inject:(id<FeedDataSourceInterface>)feedDataSourceInterface;

@end

