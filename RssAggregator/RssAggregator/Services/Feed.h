//
//  Feed.h
//  RssAggregator
//
//  Created by admin on 07/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject <NSCoding, NSCopying>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *address;

@end
