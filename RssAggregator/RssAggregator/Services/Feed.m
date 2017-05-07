//
//  Feed.m
//  RssAggregator
//
//  Created by admin on 07/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "Feed.h"

static NSString * const kFeedTitleKey = @"kFeedTitleKey";
static NSString * const kFeedAddressKey = @"kFeedAddressKey";

@implementation Feed

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:kFeedTitleKey];
    [aCoder encodeObject:self.address forKey:kFeedAddressKey];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]){
        _title = [aDecoder decodeObjectForKey:kFeedTitleKey];
        _address = [aDecoder decodeObjectForKey:kFeedAddressKey];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    Feed *feed = [[[self class] allocWithZone:zone] init];
    
    feed.title = [self.title copy];
    feed.address = [self.address copy];
    
    return feed;
}

- (BOOL)isEqualFeed:(Feed *)feed {
    return [self.address isEqualToString:feed.address];
}

- (BOOL)isEqual:(id)object {
    
    // don't add check by pointer/reference
    
    if (object == nil || [object isKindOfClass:[self class]] == NO) {
        return NO;
    }
    
    return [self isEqualFeed:object];
}

- (NSUInteger)hash {
    return [self.address hash] ^ [self.title hash];
}

@end
