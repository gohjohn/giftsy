//
//  YSWishItem.m
//  Giftsy
//
//  Created by YangShun on 25/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "YSWishItem.h"

@implementation YSWishItem

@synthesize image;
@synthesize name;
@synthesize where;
@synthesize price;

- (id)initWithImage:(UIImage*)img
               name:(NSString*)nm
              where:(NSString*)whr
              price:(NSString*)px {
  self = [super init];
  if (self) {
    self.image = img;
    self.name = nm;
    self.where = whr;
    self.price = px;
  }
  return self;
}

@end
