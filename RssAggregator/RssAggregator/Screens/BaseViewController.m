//
//  BaseViewController.m
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (UIActivityIndicatorView *)activityIndicator{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [_activityIndicator setCenter:CGPointMake(CGRectGetMidX(self.view.frame) - 5,
                                                  CGRectGetMidY(self.view.frame) - 5)];
        [_activityIndicator setContentMode:UIViewContentModeCenter];
        _activityIndicator.hidden = YES;
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.color = [UIColor darkGrayColor];
        
        [self.view addSubview:_activityIndicator];
        
    }
    return _activityIndicator;
}

- (void)showDecisionAlertWithMessage:(NSString *)msg okHandler:(void (^)(void))okBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (okBlock) {
            okBlock();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
