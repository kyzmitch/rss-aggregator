//
//  FullArticleViewController.m
//  RssAggregator
//
//  Created by admin on 06/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "FullArticleViewController.h"
#import <MWFeedParser/MWFeedItem.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FullArticleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UITextView *fullTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *articleImageAspectConstraint;

@end

@implementation FullArticleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backPressed)];
    
    self.titleLabel.text = self.data.title;
    self.fullTextView.text = self.data.summary;
    NSArray *enclosures = self.data.enclosures;
    NSString *urlStr;
    if (enclosures.count > 0) {
        
        NSDictionary *picture = [enclosures objectAtIndex:0];
        urlStr = [picture objectForKey:@"url"];
    }
    if (urlStr) {
        [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    else {
        self.articleImageAspectConstraint.active = NO;
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.articleImageView
                                                                  attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.articleImageView
                                                                  attribute:NSLayoutAttributeHeight multiplier:0
                                                                   constant:0];
        [NSLayoutConstraint activateConstraints:@[height]];
    }
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
