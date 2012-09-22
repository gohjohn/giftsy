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
  pausevc = [[PauseViewController alloc] init];
  pausevc.delegate = self;
  
  endvc = [[EndGameViewController alloc] init];
  endvc.delegate = self;
  
  numberOfBeersTapped = 0;
  beerArray = [[NSMutableArray alloc] init];
  
  self.view.userInteractionEnabled = YES;
  background.userInteractionEnabled = YES;
  [self displayBeer];
  
  timeLeft = 21;
  gametimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateTime)
                                             userInfo:nil
                                              repeats:YES];
  [gametimer fire];
}

- (void)yes {
  [pausevc.view removeFromSuperview];
}

- (void)no {
  [pausevc.view removeFromSuperview];
  self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self dismissViewControllerAnimated:NO completion:^(void){}];
}

- (void)updateTime {
  timeLeft--;
  timeLabel.text = [NSString stringWithFormat:@"%d", timeLeft];
  if (timeLeft == 0) {
    [self.view addSubview:endvc.view];
    [gametimer invalidate];
  }
}

- (void)displayBeer {
  for (int i = 0; i < 5; i++) {
    BeerItemViewController *beervc = [[BeerItemViewController alloc] init];
    beervc.delegate = self;
    [beerArray addObject:beervc];
    beervc.view.center = CGPointMake(20 + arc4random() % 420, 195);
    NSLog(NSStringFromCGPoint(beervc.view.center));
    [background addSubview:beervc.view];
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

- (IBAction)pause:(id)sender {
  [self.view addSubview:pausevc.view];
  [gametimer invalidate];
}

- (void)resume {
  gametimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateTime)
                                             userInfo:nil
                                              repeats:YES];
  [gametimer fire];
}

- (void)clearBeers {
  for (int i = 0; i < [beerArray count]; i++) {
    [((UIViewController*)[beerArray objectAtIndex:i]).view removeFromSuperview];
  }
}

- (void)quit {
  [pausevc.view removeFromSuperview];
  self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self dismissViewControllerAnimated:NO completion:^(void){}];
}

- (void)restart {
  [gametimer invalidate];
  [pausevc.view removeFromSuperview];
  [self clearBeers];
  timeLeft = 21;
  timeLabel.text = @"21";
  numberOfBeersTapped = 0;
  scoreLabel.text = @"0";
  [self displayBeer];
  gametimer = nil;
  gametimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateTime)
                                             userInfo:nil
                                              repeats:YES];
  [gametimer fire];
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
