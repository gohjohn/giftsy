//
//  TapGameViewController.h
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeerItemViewController.h"

@interface TapGameViewController : UIViewController <tapGame> {
  
  NSMutableArray *beerArray;
  int numberOfBeersTapped;
  IBOutlet UILabel *scoreLabel;
}

@end
