//
//  YSWishItem.h
//  Giftsy
//
//  Created by YangShun on 25/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YSWishItem : UIView {
  UILabel *nameLabel;
  UILabel *whereLabel;
  UILabel *priceLabel;
}

- (id)initWithImage:(UIImage*)img
               name:(NSString*)nm
              where:(NSString*)whr
              price:(NSString*)px
              owner:(NSString*)owr;

- (void)layoutIntoView;


@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *where;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *owner;

@end
