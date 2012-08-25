//
//  ViewController.h
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "FilterViewController.h"
#import "WishViewController.h"
#import "YSWishItem.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate> {
  NSMutableArray *wishArray;
}

- (void)addWishItem:(YSWishItem*)item;

@end
