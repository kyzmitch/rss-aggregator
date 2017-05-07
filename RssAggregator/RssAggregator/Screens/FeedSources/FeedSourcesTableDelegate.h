//
//  FeedSourcesTableDelegate.h
//  RssAggregator
//
//  Created by admin on 06/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FeedDelegateBackProtocol <NSObject>

- (void)feedDidRemoveAtIndexPath:(NSIndexPath *)index;
- (void)feedDidEditPressedAtIndexPath:(NSIndexPath *)index;

@end

@interface FeedSourcesTableDelegate : NSObject <UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray<NSString *> *dataSource;
@property (weak, nonatomic) id<FeedDelegateBackProtocol> backDelegate;

@end
