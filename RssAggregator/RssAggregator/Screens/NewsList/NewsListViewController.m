//
//  NewsListViewController.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsListPresenterImpl.h"
#import "NewsListTableDataSource.h"
#import "NewsListTableDelegate.h"
#import "FullArticleViewController.h"
#import "UIStoryboard+Custom.h"
#import "Feed.h" // only to fix warning about NSCopying

@interface NewsListViewController () <FeedsDelegate, NewsListView, NewsListBackDelegate>

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (strong, nonatomic) NewsListTableDataSource *tableDataSource;
@property (strong, nonatomic) NewsListPresenterImpl *presenter;
@property (strong, nonatomic) NewsListTableDelegate *tableDelegate;

@end

@implementation NewsListViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.title = @"News";
    _tableDataSource = [NewsListTableDataSource new];
    _presenter = [[NewsListPresenterImpl alloc] initWithView:self];
    _tableDelegate = [NewsListTableDelegate new];
    _tableDelegate.delegate = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.newsTableView.estimatedRowHeight = 80;
    self.newsTableView.dataSource = self.tableDataSource;
    self.newsTableView.delegate = self.tableDelegate;
}

#pragma mark - FeedInjectable

- (void)inject:(id<FeedDataSourceInterface>)feedDataSourceInterface {
    feedDataSourceInterface.delegate = self;
}

#pragma mark - FeedsDelegate

- (void)feedSourcesFetched:(NSArray<Feed *> *)sources {
    [self.presenter fetchItemsForFeedSources:sources];
}

- (void)feedDidRemove:(Feed *)feed {
    NSUInteger ix = [[self.tableDataSource.source allKeys] indexOfObject:feed];
    [self.tableDataSource.source removeObjectForKey:feed];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:ix];
    
    [self.newsTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}


- (void)feedDidAdd:(Feed *)value {
    [self.presenter fetchItemsForOneSource:value];
}

- (void)feedDidUpdatedAtIndex:(NSUInteger)index withSource:(Feed *)source {
    [self.presenter updateItemsForIndex:index withSource:source];
}

#pragma mark - NewsListView

- (void)feedItemsLoaded:(NSMutableDictionary<Feed *, NSMutableArray *> *)itemsDictionary {
    self.tableDataSource.source = itemsDictionary;
    [self.newsTableView reloadData];
}

- (void)feedItemsLoaded:(NSMutableArray *)items forSource:(Feed *)sourceAddess {
    [self.tableDataSource.source setObject:items forKey:sourceAddess];
    NSArray *keys = [self.tableDataSource.source allKeys];
    NSUInteger ix = [keys indexOfObject:sourceAddess];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:ix];
    
    [self.newsTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)feedRemoved:(Feed *)feed fromIndex:(NSUInteger)index {
    [self.tableDataSource.source removeObjectForKey:feed];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.newsTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)feedTitleUpdated:(Feed *)feed forIndex:(NSUInteger)index {
    NSArray *keys = [self.tableDataSource.source allKeys];
    Feed *key = [keys objectAtIndex:index];
    key.title = feed.title;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    
    [self.newsTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)feedItemsUpdated:(NSMutableArray *)items forSource:(Feed *)source {
    [self.tableDataSource.source setObject:items forKey:source];
    NSArray *keys = [self.tableDataSource.source allKeys];
    NSUInteger ix = [keys indexOfObject:source];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:ix];
    
    [self.newsTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)failedLoadFeedItems {
    
}

#pragma mark - Common View

- (void)showProgress{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)hideProgress{
    [self.activityIndicator stopAnimating];
}

#pragma mark - NewsListBackDelegate

- (void)articleDidSelectAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *keys = [self.tableDataSource.source allKeys];
    Feed *key = [keys objectAtIndex:indexPath.section];
    NSMutableArray *items = [self.tableDataSource.source objectForKey:key];
    MWFeedItem *item = [items objectAtIndex:indexPath.row];
    
    FullArticleViewController *fullArticleCtrl = [UIStoryboard fullArticleController];
    fullArticleCtrl.data = item;
    [self.navigationController pushViewController:fullArticleCtrl animated:YES];
}

@end
