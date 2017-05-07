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

- (void)feedSourcesLoaded:(NSArray<Feed *> *)sources {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:sources];
    self.dataSource.dataSource = arr;
    self.tableDelegate.dataSource = arr;
    [self.feedSources reloadData];
}

- (void)failedLoadFeedSources {
    [self showAlertWithMessage:@"Failed load feed sources"];
}

- (void)feedRemoved:(Feed *)feed atIndex:(NSUInteger)ix {
    [self.dataSource.dataSource removeObject:feed];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ix inSection:0];
    [self.feedSources deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)feedAdded:(Feed *)feedAddress {
    [self.dataSource.dataSource insertObject:feedAddress atIndex:0];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.feedSources insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)feedUpdated:(Feed *)feed atIndex:(NSUInteger)ix {
    [self.dataSource.dataSource replaceObjectAtIndex:ix withObject:feed];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ix inSection:0];
    [self.feedSources reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    [self showDecisionAlertWithMessage:@"Are you sure you want to remove it?" okHandler:^{
        [self.presenter removeFeedSourceAtIndex:index.row];
    }];
}

- (void)feedDidEditPressedAtIndexPath:(NSIndexPath *)index {
    Feed *feedToUpdate = [self.dataSource.dataSource objectAtIndex:index.row];
    if (feedToUpdate == nil) {
        return;
    }
    
    AddFeedViewController *addFeedCtrl = [UIStoryboard addFeedController];
    addFeedCtrl.delegate = self;
    addFeedCtrl.feedForUpdate = feedToUpdate;
    
    [self.navigationController pushViewController:addFeedCtrl animated:YES];
}

#pragma mark - FeedAddBackProtocol

- (void)feedDidCreate:(Feed *)feedAddress {
    [self.presenter addFeed:feedAddress];
}

- (void)feedDidUpdate:(Feed *)feed withNewFeed:(Feed *)newFeed {
    [self.presenter updateFeed:feed withNewFeed:newFeed];
}

@end
