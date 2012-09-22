//
//  AppDelegate.h
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"

extern NSString *const SCSessionStateChangedNotification;

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void)openSession;
- (NSMutableArray*)retrieveWishesBy:(NSString*)userid;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) NSMutableArray *universalWishList;

@property (strong, nonatomic) NSString *userId;

@end
