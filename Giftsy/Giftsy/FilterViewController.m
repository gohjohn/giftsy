//
//  FilterViewController.m
//  CameraAndFilter
//
//  Created by Yang Shun Tay on 24/5/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "FilterViewController.h"
#import "UIImage+FiltrrCompositions.h"
#import "UIImage+Scale.h"

#define kFilterButtonSize 64
#define kNumberOfFilters 12

@implementation FilterViewController

@synthesize selectedImageView;
@synthesize originalImage;

- (void)viewDidLoad {
  [self prepareFilterSelection];
  
}

- (void)prepareFilterSelection {
  
  arrEffects = [[NSMutableArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:@"Original",@"title",@"",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E1",@"title",@"e1",@"method", nil], 
                [NSDictionary dictionaryWithObjectsAndKeys:@"E2",@"title",@"e2",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E3",@"title",@"e3",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E4",@"title",@"e4",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E5",@"title",@"e5",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E6",@"title",@"e6",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E7",@"title",@"e7",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E8",@"title",@"e8",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E9",@"title",@"e9",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E10",@"title",@"e10",@"method", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"E11",@"title",@"e11",@"method", nil],
                nil];
  
  thumbImage = [originalImage scaleToSize:CGSizeMake(320, 320)];
  miniThumbImage = [thumbImage scaleToSize:CGSizeMake(50, 50)];
  selectedImageView.image = originalImage;
  
  [self setupFilterIcons];
}

- (void)setupFilterIcons {
  // MODIFIES: Self (view)
  // REQUIRES: Recipe View to be initialized.
  // EFFECTS: Various elements of the recipe is initialized and displayed.
  
  for (int i = 0; i < kNumberOfFilters; i++) {

    NSDictionary *dict = [arrEffects objectAtIndex:i];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFilterButtonSize, 80)];

    UIButton *filterIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    filterIcon.frame = CGRectMake(0, 0, 50, 50);
    filterIcon.center = CGPointMake(32, 28);
    filterIcon.tag = i;
    
    NSLog(@"%d", i);
    
    if(((NSString *)[dict valueForKey:@"method"]).length > 0) {
      SEL _selector = NSSelectorFromString([dict valueForKey:@"method"]);
      [filterIcon setImage:[miniThumbImage performSelector:_selector] forState:UIControlStateNormal];
    } else {
      [filterIcon setImage:miniThumbImage forState:UIControlStateNormal];
    }
    
    [filterIcon addTarget:self 
                   action:@selector(showFilteredImage:) 
         forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:filterIcon];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 21)];
    nameLabel.center = CGPointMake(32, 66);
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = UITextAlignmentCenter;
    nameLabel.text = [dict valueForKey:@"title"];
    [view addSubview:nameLabel];
    
    [filterSelectionView addSubview:view];
  }
  [self layoutScrollImages];
}

- (void)layoutScrollImages {
  // MODIFIES: Self (scrollview)
  // REQUIRES: Various pages of scrollview to be initialized.
  // EFFECTS: Scrollview pages are laid out nicely.
	UIImageView *view = nil;
	NSArray *subviews = [filterSelectionView subviews];
  
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = -128;
	for (view in subviews) {
		if ([view isKindOfClass:[UIView class]]) {
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
      NSLog(@"%f", curXLoc);
			curXLoc += kFilterButtonSize;
  
		}
	}
	
  filterSelectionView.contentSize = CGSizeMake(kNumberOfFilters * kFilterButtonSize, 80);
  NSLog(@"scroll view:%@", NSStringFromCGRect(filterSelectionView.frame));
  NSLog(@"scroll view content:%@", NSStringFromCGSize(filterSelectionView.contentSize));
}

- (void)showFilteredImage:(id)sender {
  UIButton *button = sender;
  if (((NSString *)[[arrEffects objectAtIndex:button.tag] valueForKey:@"method"]).length > 0) {
    
    SEL _selector = NSSelectorFromString([[arrEffects objectAtIndex:button.tag] valueForKey:@"method"]);
    selectedImageView.image = [thumbImage performSelector:_selector];
  } else {
    selectedImageView.image = thumbImage;
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
