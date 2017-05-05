//
//  NSString+Custom.m
//  RssAggregator
//
//  Created by admin on 05/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

+ (const char *)bundleNameWithSuffix:(NSString *)suffix{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    return [[NSString stringWithFormat:@"%@.%@", bundleIdentifier, suffix] cStringUsingEncoding:NSASCIIStringEncoding];
}

@end
