//
//  ViewController.m
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Logout"
                                            style:UIBarButtonItemStyleBordered
                                            target:self
                                            action:@selector(logoutButtonWasPressed:)];
}

-(void)logoutButtonWasPressed:(id)sender {
  [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
