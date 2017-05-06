//
//  AppDelegate.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "AppDelegate.h"
#import "UITabBarController+Custom.h"
#import "FeedsLocalDataSource.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UITabBarController *tabBarController = [UITabBarController tabBarControllerWithDataSource:[FeedsLocalDataSource hardcodedFeeds]];
    self.window.rootViewController = tabBarController;
    
    return YES;
}

@end
