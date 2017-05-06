//
//  FeedDataSourceInterface.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedsDelegate <NSObject>

@required
- (void)feedSourcesFetched:(NSArray<NSString *> *)sources;
@optional
- (void)feedDidAdd:(NSString *)value;
- (void)feedDidRemove:(NSString *)feed;
- (void)feedDidUpdatedAtIndex:(NSUInteger)index withSource:(NSString *)source;

@end

@protocol FeedDataSourceInterface <NSObject>

@required
- (NSArray<NSString *> *)fetch;
@property (weak, nonatomic) id<FeedsDelegate> delegate;

@optional
- (void)addSource:(NSString *)s;
- (NSString *)removeSourceAtIndex:(NSUInteger)index;
- (void)updateSourceAtIndex:(NSUInteger)index withSource:(NSString *)s;

@end

@protocol FeedInjectable <NSObject>

@required
- (void)inject:(id<FeedDataSourceInterface>)feedDataSourceInterface;

@end

