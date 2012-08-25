//
//  YSWishItem.m
//  Giftsy
//
//  Created by YangShun on 25/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "YSWishItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation YSWishItem

@synthesize image;
@synthesize name;
@synthesize where;
@synthesize price;

- (id)initWithImage:(UIImage*)img
               name:(NSString*)nm
              where:(NSString*)whr
              price:(NSString*)px
              owner:(NSString*)owr{
  self = [super init];
  if (self) {
    self.image = img;
    self.name = nm;
    self.where = whr;
    self.price = px;
    self.owner = owr;
  }
  return self;
}

- (void)layoutIntoView {
  self.tag = 1;
  self.frame = CGRectMake(0, 0, 300, 60);
  self.backgroundColor = [UIColor colorWithRed:233.0/256.0f green:233.0/256.0f blue:233.0/256.0f alpha:1.0];
  UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];

  thumbnail.image = self.image;
  [self addSubview: thumbnail];
  nameLabel = [[UILabel alloc] init];
  nameLabel.text = self.name;
  nameLabel.backgroundColor = [UIColor clearColor];
  nameLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
  nameLabel.frame = CGRectMake(70, 5, 200, 25);
  [nameLabel setFont:[UIFont boldSystemFontOfSize:20]];
  [self addSubview:nameLabel];
  
  whereLabel = [[UILabel alloc] init];
  whereLabel.text = self.where;
  whereLabel.backgroundColor = [UIColor clearColor];
  whereLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
  whereLabel.textColor = [UIColor colorWithRed:35.0/255.0f
                                         green:109.0/255.0f
                                          blue:178/255.0f
                                         alpha:1.0];
  whereLabel.frame = CGRectMake(70, 30, 200, 20);
  [self addSubview:whereLabel];
  
  priceLabel = [[UILabel alloc] init];
  priceLabel.text = self.price;
  priceLabel.backgroundColor = [UIColor clearColor];
  priceLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
  priceLabel.frame = CGRectMake(230, 10, 100, 40);
  [priceLabel setFont:[UIFont boldSystemFontOfSize:20]];
  [self addSubview:priceLabel];
  
  self.layer.shadowOffset = CGSizeMake(0, 10);
  self.layer.shadowRadius = 5;
  self.layer.shadowOpacity = 0.5;
  
}

@end
