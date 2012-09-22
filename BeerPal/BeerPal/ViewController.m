//
//  ViewController.m
//  BeerPal
//
//  Created by YangShun on 21/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "ViewController.h"
#import "TapGameViewController.h"
#import "DrinkGameViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushTapGame:(id)sender {
  TapGameViewController *tapgamevc = [[TapGameViewController alloc] init];
  [self presentViewController:tapgamevc animated:YES completion:^(void){}];
}

- (IBAction)pushDrinkGame:(id)sender {
  DrinkGameViewController *drinkgamevc = [[DrinkGameViewController alloc] init];
  [self presentViewController:drinkgamevc animated:YES completion:^(void){}];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
