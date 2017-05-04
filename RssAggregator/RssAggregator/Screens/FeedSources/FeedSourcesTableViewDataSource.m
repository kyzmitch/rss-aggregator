//
//  FeedSourcesTableViewDataSource.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "FeedSourcesTableViewDataSource.h"

@implementation FeedSourcesTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kFeedSourceCellId" forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

@end
