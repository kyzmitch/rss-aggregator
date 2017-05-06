//
//  AddFeedViewController.h
//  RssAggregator
//
//  Created by admin on 06/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "BaseViewController.h"

@protocol FeedAddBackProtocol <NSObject>

- (void)feedDidCreate:(NSString *)feedAddress;

@end

@interface AddFeedViewController : BaseViewController

@property (weak, nonatomic) id<FeedAddBackProtocol> delegate;
@end
