//
//  NewsListViewController.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "NewsListViewController.h"

@interface NewsListViewController () <FeedsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@end

@implementation NewsListViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.title = @"News";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - FeedInjectable

- (void)inject:(id<FeedDataSourceInterface>)feedDataSourceInterface {
    feedDataSourceInterface.delegate = self;
}

#pragma mark - FeedsDelegate

- (void)feedSourcesFetched:(NSArray<NSString *> *)sources {
    
}

@end
