//
//  ProfileViewController.m
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userBirthdayLabel;

@end

@implementation ProfileViewController

@synthesize userid;
@synthesize username;
@synthesize userbirthday;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  if (FBSession.activeSession.isOpen) {
    [[FBRequest requestForMyFriends] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
       if (!error) {
         self.userNameLabel.text = self.username;
         [self.userNameLabel setFont:[UIFont boldSystemFontOfSize:16]];
         self.userProfileImage.profileID = self.userid;
         NSLog(@"User id:%@", self.userProfileImage.profileID);
         self.userBirthdayLabel.text = self.userbirthday;
         currentid = self.userid;
         [self loadWishItems];
       }
     }];
    [self.userProfileImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.userProfileImage.layer setBorderWidth: 2.0];
    self.userProfileImage.layer.shadowOffset = CGSizeMake(5, 5);
    self.userProfileImage.layer.shadowRadius = 4;
    self.userProfileImage.layer.shadowOpacity = 0.5;
    // Do any additional setup after loading the view from its nib.
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [self loadWishItems];
}

- (void)loadWishItems {
  
  AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
  
  wishArray = [appDelegate retrieveWishesBy:currentid];
  int number = [wishArray count];
  NSLog(@"count: %d", number);
  [wishList setContentSize:CGSizeMake(300, (number * 70))];
  for (UIView *view in wishArray) {
    NSLog(@"view added into scroll");
    [wishList addSubview:view];
  }
  
  NSArray *subviews = [wishList subviews];
  NSLog(@"number of subviews: %d", [subviews count]);
  CGFloat curYLoc = 0;
	for (UIView *view in subviews) {
    if ([view isKindOfClass:[UIView class]] && view.tag > 0) {
			CGRect frame = view.frame;
			frame.origin = CGPointMake(0, curYLoc);
			view.frame = frame;
			curYLoc += 70;
    }
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
