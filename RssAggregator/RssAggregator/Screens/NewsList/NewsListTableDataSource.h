//
//  NewsListTableDataSource.h
//  RssAggregator
//
//  Created by admin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Feed;

@interface NewsListTableDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSMutableDictionary<Feed *, NSMutableArray *> *source;

@end
