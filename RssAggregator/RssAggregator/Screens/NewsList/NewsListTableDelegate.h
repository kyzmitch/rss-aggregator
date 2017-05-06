//
//  NewsListTableDelegate.h
//  RssAggregator
//
//  Created by admin on 06/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NewsListBackDelegate <NSObject>

- (void)articleDidSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NewsListTableDelegate : NSObject <UITableViewDelegate>

@property (weak, nonatomic) id<NewsListBackDelegate> delegate;

@end
