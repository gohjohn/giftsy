//
//  EndGameViewController.m
//  BeerPal
//
//  Created by YangShun on 22/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "EndGameViewController.h"

@interface EndGameViewController () {
 
  UIImage *loseImage;
  IBOutlet UIImageView *outcomeLose;
  
}

@end

@implementation EndGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      loseImage = [UIImage imageNamed:@"lose.png"];
        // Custom initialization
    }
    return self;
}

- (void)setLoseImage {
  self.outcome.image = loseImage;
  NSLog(@"set lose image");
}

- (IBAction)yes {
  [self.delegate yes];
}

- (IBAction)no {
  [self.delegate no];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
