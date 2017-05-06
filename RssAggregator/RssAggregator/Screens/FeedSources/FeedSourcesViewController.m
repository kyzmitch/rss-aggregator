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

@interface FeedSourcesViewController () <FeedSourcesView, FeedDelegateBackProtocol>

@property (weak, nonatomic) IBOutlet UITableView *feedSources;
@property (strong, nonatomic) id<FeedSourcesPresenter> presenter;
@property (strong, nonatomic) FeedSourcesTableViewDataSource *dataSource;
@property (strong, nonatomic) FeedSourcesTableDelegate *tableDelegate;

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
    _presenter = [[FeedSourcesPresenterImpl alloc] initWithView:self source:feedDataSourceInterface];
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

@end
