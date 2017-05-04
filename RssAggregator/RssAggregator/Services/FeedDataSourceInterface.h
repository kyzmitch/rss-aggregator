//
//  FeedDataSourceInterface.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedsDelegate <NSObject>

@optional
- (void)feedDidAdd:(NSString *)value;
- (void)feedDidRemoveAtIndex:(NSUInteger)index;
- (void)feedDidUpdatedAtIndex:(NSUInteger)index withSource:(NSString *)source;

@end

@protocol FeedDataSourceInterface <NSObject>

@required
- (NSArray<NSString *> *)fetch;
@property (weak, nonatomic) id<FeedsDelegate> delegate;

@optional
- (void)addSource:(NSString *)s;
- (void)removeSourceAtIndex:(NSUInteger)index;
- (void)updateSourceAtIndex:(NSUInteger)index withSource:(NSString *)s;

@end

@protocol FeedInjectable <NSObject>

@required
- (void)inject:(id<FeedDataSourceInterface>)feedDataSourceInterface;

@end

