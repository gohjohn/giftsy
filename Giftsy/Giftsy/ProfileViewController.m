//
//  ProfileViewController.m
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userBirthdayLabel;
@property (strong, nonatomic) NSMutableDictionary *postParams;

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
       }
     }];

    // Do any additional setup after loading the view from its nib.
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
