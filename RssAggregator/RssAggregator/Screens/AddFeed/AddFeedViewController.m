//
//  AddFeedViewController.m
//  RssAggregator
//
//  Created by admin on 06/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "AddFeedViewController.h"
#import "Feed.h"

@interface AddFeedViewController ()
@property (weak, nonatomic) IBOutlet UITextField *feedNameField;
@property (weak, nonatomic) IBOutlet UITextField *feedAddressField;

@end

@implementation AddFeedViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.title = @"Add Feed";
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backPressed)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed)];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addPressed {
    if (self.feedAddressField.text.length > 0 && self.feedNameField.text.length > 0) {
        NSString *address = [self.feedAddressField.text copy];
        NSString *title = [self.feedNameField.text copy];
        Feed *feed = [Feed new];
        feed.title = title;
        if ([address hasPrefix:@"http://"] || [address hasPrefix:@"https://"]) {
            feed.address = address;
            [self.delegate feedDidCreate:feed];
        }
        else {
            feed.address = [NSString stringWithFormat:@"https://%@", address];
            [self.delegate feedDidCreate:feed];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self showAlertWithMessage:@"Enter rss feed address first"];
    }
}

@end
