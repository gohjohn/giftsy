//
//  ViewController.m
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userBirthdayLabel;
@property (strong, nonatomic) NSMutableDictionary *postParams;

@end

@implementation ViewController

@synthesize postParams;

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
    FBCacheDescriptor *friendCacheDescriptor =
    [FBFriendPickerViewController cacheDescriptor];
    [friendCacheDescriptor prefetchAndCacheForSession:FBSession.activeSession];
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

- (IBAction)showFriendsAction:(id)sender {
  // Initialize the friend picker
  FBFriendPickerViewController *friendPickerController =
  [[FBFriendPickerViewController alloc] init];
  
  // Configure the picker ...
  friendPickerController.title = @"My Friends";
  // Set this view controller as the friend picker delegate
  friendPickerController.delegate = self;
  // Allow only a single friend to be selected
  friendPickerController.allowsMultipleSelection = NO;
  
  // Fetch the data
  [friendPickerController loadData];
  
  // Present view controller modally.e the deprecated
  if ([self
       respondsToSelector:@selector(presentViewController:animated:completion:)]) {
    // iOS 5+
    [self presentViewController:friendPickerController
                       animated:YES
                     completion:nil];
  } else {
    [self presentModalViewController:friendPickerController animated:YES];
  }
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
  [self dismissModalViewControllerAnimated:YES];
  
}

- (void)facebookViewControllerDoneWasPressed:(FBFriendPickerViewController *)friendPicker
{
  [self dismissModalViewControllerAnimated:YES];
  NSArray *friends = friendPicker.selection;
  id<FBGraphUser> friend = [friends objectAtIndex:0];
  ProfileViewController *pvc = [[ProfileViewController alloc] init];
  pvc.userid = friend.id;
  pvc.username = friend.name;
  pvc.userbirthday = friend.birthday;
  
//  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:friend.first_name
//                                                 message:friend.id
//                                                delegate:nil
//                                       cancelButtonTitle:@"OK"
//                                       otherButtonTitles:nil, nil];
//  [alert show];
  [self.navigationController pushViewController:pvc animated:NO];
}

- (IBAction)shareOnFacebook:(id)sender {
  
  NSString *message = [[NSString alloc] initWithFormat:@"I wished for a "];
  int count = 0;
  for (YSWishItem *item in [wishList subviews]) {
    if (count > 0) {
      [message stringByAppendingString:[NSString stringWithFormat:@", " ]];
    }
    NSLog(@"hello");
    [message stringByAppendingString:[NSString stringWithString:item.name]];
    count++;
    NSLog(@"%@", message);
  }
  
  self.postParams =
  [[NSMutableDictionary alloc] initWithObjectsAndKeys:
   @"https://www.facebook.com/pages/Giftsy/376683299071946", @"link",
   @"https://sphotos-a.xx.fbcdn.net/hphotos-ash4/294321_380592942014315_1089014929_n.jpg", @"picture",
   message, @"message",
   @"I updated my wishlist via Giftsy", @"name",
   @"Join Giftsy today to let your friends know what you wish to have!", @"caption",
   @"Giftsy is a gift collaborating app that lets you know what each other wishes for!", @"description",
   nil];
  
  [FBRequestConnection startWithGraphPath:@"me/feed"
                               parameters:self.postParams
                               HTTPMethod:@"POST"
                        completionHandler:^(FBRequestConnection *connection,
                                            id result,
                                            NSError *error) {
                          NSString *alertText;
                          if (error) {
                            alertText = [NSString stringWithFormat:
                                         @"error: domain = %@, code = %d",
                                         error.domain, error.code];
                          } else {
                            alertText = [NSString stringWithFormat:
                                         @"Successfully shared!"];
                          }
                          // Show the result in an alert
                          [[[UIAlertView alloc] initWithTitle:@"Giftsy"
                                                      message:alertText
                                                     delegate:self
                                            cancelButtonTitle:@"OK!"
                                            otherButtonTitles:nil]
                           show];
                        }];
}

@end
