//
//  PauseViewController.h
//  BeerPal
//
//  Created by YangShun on 22/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pauseActions <NSObject>

- (void)quit;
- (void)resume;
- (void)restart;

@end

@interface PauseViewController : UIViewController

@property (nonatomic, retain) id<pauseActions> delegate;

@end
