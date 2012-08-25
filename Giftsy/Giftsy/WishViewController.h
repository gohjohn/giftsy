//
//  WishViewController.h
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <QuartzCore/QuartzCore.h>

@interface WishViewController : UIViewController {
  IBOutlet UIImageView *wishImageView;
  IBOutlet UITextField *name;
  IBOutlet UITextField *where;
  IBOutlet UITextField *price;
}

@property (strong, nonatomic) UIImage *wishImage;

@end
