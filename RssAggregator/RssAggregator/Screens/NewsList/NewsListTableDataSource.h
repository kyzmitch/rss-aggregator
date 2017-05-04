//
//  NewsListTableDataSource.h
//  RssAggregator
//
//  Created by admin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsListTableDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *source;

@end
