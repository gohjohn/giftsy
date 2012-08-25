//
//  FilterViewController.h
//  CameraAndFilter
//
//  Created by Yang Shun Tay on 24/5/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController {
  
  IBOutlet UIImageView *selectedImageView;
  IBOutlet UIScrollView *filterSelectionView;
  
  UIImage *originalImage;
  NSMutableArray *arrEffects;
  UIImage *thumbImage;
  UIImage *miniThumbImage;
}

@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImageView *selectedImageView;

- (void)prepareFilterSelection;
- (void)showFilteredImage:(id)sender;

@end
