//
//  UITabBarController+Custom.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDataSourceInterface.h"

@interface UITabBarController (Custom)

+ (nullable UITabBarController *)tabBarControllerWithDataSource:(nonnull id<FeedDataSourceInterface>)dataSource;

@end
