//
//  FeedSourcesTableViewDataSource.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Feed;

@interface FeedSourcesTableViewDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray<Feed *> *dataSource;

@end
