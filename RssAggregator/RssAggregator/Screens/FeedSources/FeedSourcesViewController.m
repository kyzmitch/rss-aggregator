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

@interface FeedSourcesViewController () <FeedSourcesView>

@property (weak, nonatomic) IBOutlet UITableView *feedSources;
@property (strong, nonatomic) id<FeedSourcesPresenter> presenter;
@property (strong, nonatomic) FeedSourcesTableViewDataSource *dataSource;

@end

@implementation FeedSourcesViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.title = @"Feed sources";
    _dataSource = [FeedSourcesTableViewDataSource new];
    
    return self;
}

- (void)inject:(id<FeedDataSourceInterface>)feedDataSourceInterface {
    _presenter = [[FeedSourcesPresenterImpl alloc] initWithView:self source:feedDataSourceInterface];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSource)];
    self.feedSources.dataSource = self.dataSource;
    
    // load only once
    [self.presenter loadFeedSources];
}

- (void)addSource {
    
}

#pragma mark - FeedSourcesView

- (void)feedSourcesLoaded:(NSArray<NSString *> *)sources {
    self.dataSource.dataSource = sources;
    [self.feedSources reloadData];
}

- (void)failedLoadFeedSources {
    [self showAlertWithMessage:@"Failed load feed sources"];
}

#pragma mark - Common View

- (void)showProgress{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)hideProgress{
    [self.activityIndicator stopAnimating];
}

@end
