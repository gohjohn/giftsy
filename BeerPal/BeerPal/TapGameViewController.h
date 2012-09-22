//
//  TapGameViewController.h
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeerItemViewController.h"
#import "PauseViewController.h"

@interface TapGameViewController : UIViewController <tapGame, pauseActions> {
  
  NSMutableArray *beerArray;
  int numberOfBeersTapped;
  IBOutlet UILabel *scoreLabel;
  IBOutlet UIImageView *background;
  PauseViewController *pausevc;
  IBOutlet UILabel *timeLabel;
  NSTimer *gametimer;
  int timeLeft;
}

@end
