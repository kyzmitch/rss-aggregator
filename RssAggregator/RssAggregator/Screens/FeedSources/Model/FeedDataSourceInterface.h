//
//  FeedDataSourceInterface.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedDataSourceInterface <NSObject>

@required
- (NSArray<NSString *> *)fetch;

@end
