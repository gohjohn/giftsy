//
//  ViewController.m
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userBirthdayLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//  self.navigationController.navigationBar.tintColor = [UIColor redColor];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Logout"
                                            style:UIBarButtonItemStyleBordered
                                            target:self
                                            action:@selector(logoutButtonWasPressed:)];
//  self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(sessionStateChanged:)
                                               name:@"SessionStateChangedNotification"
                                             object:nil];
  
  wishArray = [[NSMutableArray alloc] init];

}

- (void)populateUserDetails {
  if (FBSession.activeSession.isOpen) {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
       if (!error) {
         self.userNameLabel.text = user.name;
         [self.userNameLabel setFont:[UIFont boldSystemFontOfSize:16]];
         self.userProfileImage.profileID = user.id;
         self.userBirthdayLabel.text = user.birthday;
         NSLog(@"%@", user.birthday);
       }
     }];
  }
}

- (void)sessionStateChanged:(NSNotification*)notification {
  [self populateUserDetails];
}

- (void)logoutButtonWasPressed:(id)sender {
  [FBSession.activeSession closeAndClearTokenInformation];
}

- (IBAction)addGiftButton:(id)sender {
  UIImagePickerController *libraryPicker = [[UIImagePickerController alloc] init];
  libraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  libraryPicker.delegate = self;
  [self presentModalViewController:libraryPicker animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (FBSession.activeSession.isOpen) {
    [self populateUserDetails];
  }
  
  [self.userProfileImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
  [self.userProfileImage.layer setBorderWidth: 2.0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [self dismissModalViewControllerAnimated:NO];
  WishViewController *wishvc = [[WishViewController alloc] init];
  UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  NSLog(@"image size:%@", NSStringFromCGSize(selectedImage.size));
  wishvc.wishImage = selectedImage;
  [self.navigationController pushViewController:wishvc animated:YES];
}

- (void)viewDidUnload {
  [super viewDidUnload];
    // Release any retained subviews of the main view.
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)addWishItem:(YSWishItem*)item {
  [wishArray addObject:item];
}

- (void)loadWishItems {
  
}


@end
