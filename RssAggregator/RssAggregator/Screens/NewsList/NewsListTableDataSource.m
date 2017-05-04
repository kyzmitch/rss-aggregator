//
//  NewsListTableDataSource.m
//  RssAggregator
//
//  Created by admin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "NewsListTableDataSource.h"

@implementation NewsListTableDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.source allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *keys = [self.source allKeys];
    NSString *key = [keys objectAtIndex:section];
    return [self.source objectForKey:key].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kNewsPreviewCellId" forIndexPath:indexPath];
    NSArray *keys = [self.source allKeys];
    NSString *key = [keys objectAtIndex:indexPath.section];
    id article = [[self.source objectForKey:key] objectAtIndex:indexPath.row];
    cell.textLabel.text = @"TODO";
    return cell;
}

@end
