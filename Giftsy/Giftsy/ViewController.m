//
//  ViewController.m
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

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
         NSLog(@"User id:%@", self.userProfileImage.profileID);
         self.userBirthdayLabel.text = user.birthday;
         NSLog(@"%@", user.birthday);
         
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         appDelegate.userId = self.userProfileImage.profileID;
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
  self.userProfileImage.layer.shadowOffset = CGSizeMake(5, 5);
  self.userProfileImage.layer.shadowRadius = 4;
  self.userProfileImage.layer.shadowOpacity = 0.5;
  [self loadWishItems];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [self dismissModalViewControllerAnimated:NO];
  WishViewController *wishvc = [[WishViewController alloc] init];
  UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  NSLog(@"image size:%@", NSStringFromCGSize(selectedImage.size));
  wishvc.wishImage = selectedImage;
  wishvc.delegate = self;
  [self.navigationController pushViewController:wishvc animated:NO];
}

- (void)viewDidUnload {
  [super viewDidUnload];
    // Release any retained subviews of the main view.
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)addWishItem:(YSWishItem*)item {
  if (!item) {
    NSLog(@"wish item is null");
  }
  [wishArray addObject:item];
  NSLog(@"wish item added");
}

- (void)loadWishItems {
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

@end
