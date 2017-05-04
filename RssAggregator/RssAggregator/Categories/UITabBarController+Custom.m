//
//  UITabBarController+Custom.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "UITabBarController+Custom.h"
#import "UIStoryboard+Custom.h"
#import "NewsListViewController.h"
#import "FeedSourcesViewController.h"

@implementation UITabBarController (Custom)

+(nullable UITabBarController *)tabBarControllerWithDataSource:(id<FeedDataSourceInterface>)dataSource {
    FeedSourcesViewController *feedSources = [UIStoryboard feedSourcesController];
    NewsListViewController *newsList = [UIStoryboard newsListController];
    [feedSources inject:dataSource];
    [newsList inject:dataSource];
    
    UINavigationController *feedSourcesNavCtrl = [[UINavigationController alloc] initWithRootViewController:feedSources];
    UINavigationController *newsListNavCtrl = [[UINavigationController alloc] initWithRootViewController:newsList];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[feedSourcesNavCtrl, newsListNavCtrl] animated:NO];
    
    return tabBarController;
}

@end
