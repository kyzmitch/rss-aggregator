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
#import "FeedsLocalDataSource.h"

@interface FeedSourcesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *feedSources;
@property (strong, nonatomic) id<FeedSourcesPresenter> presenter;

@end

@implementation FeedSourcesViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.title = @"Feed sources";
    _presenter = [[FeedSourcesPresenterImpl alloc] initWithView:self source:[FeedsLocalDataSource new]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSource)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.presenter loadFeedSources];
}

- (void)addSource {
    
}

#pragma mark - FeedSourcesView

- (void)feedSourcesLoaded:(NSArray<NSString *> *)sources {
    self.feedSources.dataSource = [FeedSourcesTableViewDataSource new];
    [self.feedSources reloadData];
}

- (void)failedLoadFeedSources {
    
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
