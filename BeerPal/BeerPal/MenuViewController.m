//
//  MenuViewController.m
//  BeerPal
//
//  Created by YangShun on 22/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
  checkvc = [[CheckViewController alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)quit:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cocktail:(id)sender {
  
  [self presentModalViewController:checkvc animated:YES];
  [checkvc loadItem:@"Cocktail" Price:900 Qn:1];
}

- (IBAction)beer:(id)sender {
  [self presentModalViewController:checkvc animated:YES];
  [checkvc loadItem:@"Beer" Price:550 Qn:1];
  
}

- (IBAction)shots:(id)sender {
  [self presentModalViewController:checkvc animated:YES];
  [checkvc loadItem:@"Shots" Price:710 Qn:1];
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
