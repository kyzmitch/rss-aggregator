//
//  FeedSourcesViewController.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "FeedSourcesViewController.h"
#import "FeedSourcesTableViewDataSource.h"
#import "FeedSourcesPresenterImpl.h"
#import "FeedSourcesTableDelegate.h"
#import "AddFeedViewController.h"
#import "UIStoryboard+Custom.h"

@interface FeedSourcesViewController () <FeedSourcesView, FeedDelegateBackProtocol, FeedAddBackProtocol>

@property (weak, nonatomic) IBOutlet UITableView *feedSources;
@property (strong, nonatomic) id<FeedSourcesPresenter> presenter;
@property (strong, nonatomic) FeedSourcesTableViewDataSource *dataSource;
@property (strong, nonatomic) FeedSourcesTableDelegate *tableDelegate;
@property (strong, nonatomic) id<FeedDataSourceInterface> feedSource; // just for add feed controller

@end

@implementation FeedSourcesViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.title = @"Feed sources";
    _dataSource = [FeedSourcesTableViewDataSource new];
    _tableDelegate = [FeedSourcesTableDelegate new];
    _tableDelegate.backDelegate = self;
    
    return self;
}

- (void)inject:(id<FeedDataSourceInterface>)feedDataSourceInterface {
    self.presenter = [[FeedSourcesPresenterImpl alloc] initWithView:self source:feedDataSourceInterface];
    self.feedSource = feedDataSourceInterface;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.feedSources.estimatedRowHeight = 50;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSource)];
    self.feedSources.dataSource = self.dataSource;
    self.feedSources.delegate = self.tableDelegate;
    
    [self.presenter loadFeedSources];
}

- (void)addSource {
    AddFeedViewController *addFeedCtrl = [UIStoryboard addFeedController];
    addFeedCtrl.delegate = self;
    [self.navigationController pushViewController:addFeedCtrl animated:YES];
}

#pragma mark - FeedSourcesView

- (void)feedSourcesLoaded:(NSArray<NSString *> *)sources {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:sources];
    self.dataSource.dataSource = arr;
    self.tableDelegate.dataSource = arr;
    [self.feedSources reloadData];
}

- (void)failedLoadFeedSources {
    [self showAlertWithMessage:@"Failed load feed sources"];
}

- (void)feedRemoved:(NSString *)feed atIndex:(NSUInteger)ix {
    [self.dataSource.dataSource removeObject:feed];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ix inSection:0];
    [self.feedSources deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)feedAdded:(NSString *)feedAddress {
    [self.dataSource.dataSource insertObject:feedAddress atIndex:0];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.feedSources insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Common View

- (void)showProgress{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)hideProgress{
    [self.activityIndicator stopAnimating];
}

#pragma mark - BackDelegate

- (void)feedDidRemoveAtIndexPath:(NSIndexPath *)index {
    [self.presenter removeFeedSourceAtIndex:index.row];
}

#pragma mark - FeedAddBackProtocol

- (void)feedDidCreate:(NSString *)feedAddress {
    [self.presenter addFeed:feedAddress];
}

@end
