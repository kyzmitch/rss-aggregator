//
//  UIStoryboard+Custom.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsListViewController, FeedSourcesViewController;

@interface UIStoryboard (Custom)

+ (NewsListViewController *)newsListController;
+ (FeedSourcesViewController *)feedSourcesController;

@end
