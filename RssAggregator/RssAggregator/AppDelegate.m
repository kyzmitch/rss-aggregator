//
//  AppDelegate.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "AppDelegate.h"
#import "UITabBarController+Custom.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UITabBarController *tabBarController = [UITabBarController customTabBarController];
    self.window.rootViewController = tabBarController;
    
    return YES;
}

@end
