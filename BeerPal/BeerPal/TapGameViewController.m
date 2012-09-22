//
//  TapGameViewController.m
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "TapGameViewController.h"

@interface TapGameViewController ()

@end

@implementation TapGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  numberOfBeersTapped = 0;
  beerArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < 5; i++) {
  }
  self.view.userInteractionEnabled = YES;
  [self displayBeer];
}

- (void)displayBeer {
  for (int i = 0; i < 5; i++) {
    
    BeerItemViewController *beervc = [[BeerItemViewController alloc] init];
    beervc.delegate = self;
    [beerArray addObject:beervc];
    beervc.view.center = CGPointMake(arc4random() % 480, arc4random() % 320);
    NSLog(NSStringFromCGPoint(beervc.view.center));
    beervc.view.transform = CGAffineTransformRotate(beervc.view.transform, ((CGFloat)arc4random())/360.0);
    [self.view addSubview:beervc.view];
  }
}

- (void)increaseCount:(id)sender {
  numberOfBeersTapped++;
  [((UIViewController*)sender).view removeFromSuperview];
  scoreLabel.text = [NSString stringWithFormat:@"%d", numberOfBeersTapped];
  [beerArray removeObject:(BeerItemViewController*)sender];
  if (numberOfBeersTapped % 5 == 0) {
//    NSLog(@"display beer");
    [self displayBeer];
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
