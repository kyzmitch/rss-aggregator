//
//  UIStoryboard+Custom.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "UIStoryboard+Custom.h"

@interface StoryboardFabric : NSObject

+ (UIStoryboard *)feedSources;
+ (UIStoryboard *)newsList;

@end

@implementation StoryboardFabric

+ (UIStoryboard *)feedSources {
    static UIStoryboard * board = nil;
    if (board == nil) {
        board = [UIStoryboard storyboardWithName:@"FeedSources" bundle:[NSBundle bundleForClass:[self class]]];
    }
    return board;
}

+ (UIStoryboard *)newsList {
    static UIStoryboard * board = nil;
    if (board == nil) {
        board = [UIStoryboard storyboardWithName:@"NewsList" bundle:[NSBundle bundleForClass:[self class]]];
    }
    return board;
}

@end

@implementation UIStoryboard (Custom)

+ (NewsListViewController *)newsListController {
    return (NewsListViewController *) [[StoryboardFabric newsList] instantiateViewControllerWithIdentifier:@"newsListScreenId"];
}

+ (FeedSourcesViewController *)feedSourcesController {
    return (FeedSourcesViewController *) [[StoryboardFabric feedSources] instantiateViewControllerWithIdentifier:@"feedSourcesScreenId"];
}

+ (AddFeedViewController *)addFeedController {
    return (AddFeedViewController *) [[StoryboardFabric feedSources] instantiateViewControllerWithIdentifier:@"addFeedScreenId"];
}


+ (FullArticleViewController *)fullArticleController {
    return (FullArticleViewController *) [[StoryboardFabric newsList] instantiateViewControllerWithIdentifier:@"fullArticleScreenId"];
}

@end
