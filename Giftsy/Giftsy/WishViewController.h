//
//  WishViewController.h
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <QuartzCore/QuartzCore.h>

@protocol wishActions <NSObject>

- (void)addWishItem:(id)item;

@end

@interface WishViewController : UIViewController {
  IBOutlet UIImageView *wishImageView;
  IBOutlet UITextField *name;
  IBOutlet UITextField *where;
  IBOutlet UITextField *price;
  id<wishActions> delegate;
}

@property (strong, nonatomic) UIImage *wishImage;
@property (nonatomic, retain) id delegate;

@end
