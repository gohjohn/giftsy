//
//  LoginViewController.m
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

- (IBAction)performLogin:(id)sender;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation LoginViewController
@synthesize spinner;

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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)performLogin:(id)sender {
  [self.spinner startAnimating];
  
  AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate openSession];
}

- (void)loginFailed
{
  // User switched back to the app without authorizing. Stay here, but
  // stop the spinner.
  [self.spinner stopAnimating];
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
