//
//  EndGameViewController.h
//  BeerPal
//
//  Created by YangShun on 22/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol endActions <NSObject>

- (void)yes;
- (void)no;

@end

@interface EndGameViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *outcome;
@property (nonatomic, retain) id<endActions> delegate;

- (void)setLoseImage;

@end
