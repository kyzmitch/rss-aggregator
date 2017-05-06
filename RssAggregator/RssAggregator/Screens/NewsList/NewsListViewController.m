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

- (void)feedSourcesFetched:(NSArray<NSString *> *)sources {
    [self.presenter fetchItemsForFeedSources:sources];
}

- (void)feedDidRemove:(NSString *)feed {
    NSUInteger ix = [[self.tableDataSource.source allKeys] indexOfObject:feed];
    [self.tableDataSource.source removeObjectForKey:feed];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:ix];
    
    [self.newsTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}


- (void)feedDidAdd:(NSString *)value {
    [self.presenter fetchItemsForOneSource:value];
}

#pragma mark - NewsListView

- (void)feedItemsLoaded:(NSMutableDictionary<NSString *, NSMutableArray *> *)itemsDictionary {
    self.tableDataSource.source = itemsDictionary;
    [self.newsTableView reloadData];
}

- (void)feedItemsLoaded:(NSMutableArray *)forSource :(NSString *)sourceAddess {
    [self.tableDataSource.source setObject:forSource forKey:sourceAddess];
    NSArray *keys = [self.tableDataSource.source allKeys];
    NSUInteger ix = [keys indexOfObject:sourceAddess];
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
    NSString *key = [keys objectAtIndex:indexPath.section];
    NSMutableArray *items = [self.tableDataSource.source objectForKey:key];
    MWFeedItem *item = [items objectAtIndex:indexPath.row];
    
    FullArticleViewController *fullArticleCtrl = [UIStoryboard fullArticleController];
    fullArticleCtrl.data = item;
    [self.navigationController pushViewController:fullArticleCtrl animated:YES];
}

@end
