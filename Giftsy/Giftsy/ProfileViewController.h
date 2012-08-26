//
//  ProfileViewController.h
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController : UIViewController {
  NSMutableArray *wishArray;
  IBOutlet UIScrollView *wishList;
}

@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userbirthday;


@end
