//
//  FullArticleViewController.h
//  RssAggregator
//
//  Created by admin on 06/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "BaseViewController.h"

@class MWFeedItem;

@interface FullArticleViewController : BaseViewController

@property (strong, nonatomic) MWFeedItem *data;

@end
