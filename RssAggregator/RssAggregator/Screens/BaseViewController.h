//
//  BaseViewController.h
//  RssAggregator
//
//  Created by Andrey Ermoshin on 04/05/2017.
//  Copyright © 2017 andreiermoshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Alertable <NSObject>

- (void)showDecisionAlertWithMessage:(NSString *)msg okHandler:(void (^)(void))okBlock;
- (void)showAlertWithMessage:(NSString *)message;

@end

@interface BaseViewController : UIViewController <Alertable>

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end
