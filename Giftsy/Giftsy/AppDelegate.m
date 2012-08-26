//
//  AppDelegate.m
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import "YSWishItem.h"

NSString *const SessionStateChangedNotification =
@"app.nvc.Giftsy:SessionStateChangedNotification";

@implementation AppDelegate

@synthesize navController;
@synthesize userId;
@synthesize universalWishList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FBProfilePictureView class];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
  self.navController = [[UINavigationController alloc]
                        initWithRootViewController:self.viewController];
  self.navController.navigationItem.backBarButtonItem.tintColor = [UIColor redColor];
  if ([self.navController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
    UIImage *image = [UIImage imageNamed:@"nav-bar-image.png"];
    [self.navController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
  }
  
  self.universalWishList = [[NSMutableArray alloc] init];
  [self populateUniversalWishList];
  
  self.window.rootViewController = self.navController;
  [self.window makeKeyAndVisible];
  
  if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    // Yes, so just open the session (this won't display any UX).
    [self openSession];
  } else {
    // No, display the login page.
    [self showLoginView];
  }
  
  return YES;
}

- (void)showLoginView {
  UIViewController *topViewController = [self.navController topViewController];
  
  UIViewController *modalViewController = [topViewController modalViewController];
  
  // If the login screen is not already displayed, display it. If the login screen is
  // displayed, then getting back here means the login in progress did not successfully
  // complete. In that case, notify the login view so it can update its UI appropriately.
  if (![modalViewController isKindOfClass:[LoginViewController class]]) {
    LoginViewController* loginViewController = [[LoginViewController alloc]
                                                initWithNibName:@"LoginViewController"
                                                bundle:nil];
    [topViewController presentModalViewController:loginViewController animated:NO];
  } else {
    LoginViewController* loginViewController = (LoginViewController*)modalViewController;
    [loginViewController loginFailed];
  }
  
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error {
  switch (state) {
    case FBSessionStateOpen: {
      UIViewController *topViewController =
      [self.navController topViewController];
      if ([[topViewController modalViewController]
           isKindOfClass:[LoginViewController class]]) {
        [topViewController dismissModalViewControllerAnimated:YES];
      }
    }
      break;
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed:
      // Once the user has logged in, we want them to
      // be looking at the root view.
      [self.navController popToRootViewControllerAnimated:NO];
      
      [FBSession.activeSession closeAndClearTokenInformation];
      
      [self showLoginView];
      break;
    default:
      break;
  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangedNotification"
                                                      object:session];
  
  if (error) {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:error.localizedDescription
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
  }
}

- (void)openSession {
  NSArray *permissions = [[NSArray alloc] initWithObjects:@"user_birthday", @"friends_birthday", @"user_interests", @"publish_actions", nil];
  
  [FBSession openActiveSessionWithPermissions:permissions
                                 allowLoginUI:YES
                            completionHandler:
   ^(FBSession *session,
     FBSessionState state, NSError *error) {
     [self sessionStateChanged:session state:state error:error];
   }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  // this means the user switched back to this app without completing
  // a login in Safari/Facebook App
  if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
    [FBSession.activeSession close]; // so we close our session and start over
  }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)populateUniversalWishList {
  UIImage *img1 = [UIImage imageNamed:@"bag.jpeg"];
  YSWishItem *item1 = [[YSWishItem alloc] initWithImage:img1
                                                   name:@"Gucci Bag"
                                                  where:@"Gucci Store"
                                                  price:@"$252"
                                                  owner:@"558978353"];
  [item1 layoutIntoView];
  [self.universalWishList addObject:item1];
  
  UIImage *img2 = [UIImage imageNamed:@"bed.jpeg"];
  YSWishItem *item2 = [[YSWishItem alloc] initWithImage:img2
                                                   name:@"King Size Bed"
                                                  where:@"IKEA"
                                                  price:@"$329"
                                                  owner:@"558978353"];
  [item1 layoutIntoView];
  [self.universalWishList addObject:item2];
  
  UIImage *img3 = [UIImage imageNamed:@"camera.jpeg"];
  YSWishItem *item3 = [[YSWishItem alloc] initWithImage:img3
                                                   name:@"Vintage Camera"
                                                  where:@"That Camera Shop"
                                                  price:@"$729"
                                                  owner:@"521412386"];
  [item1 layoutIntoView];
  [self.universalWishList addObject:item3];

  UIImage *img4 = [UIImage imageNamed:@"sunglasses.jpeg"];
  YSWishItem *item4 = [[YSWishItem alloc] initWithImage:img4
                                                   name:@"Rayban Shades"
                                                  where:@"Rayban Store"
                                                  price:@"$531"
                                                  owner:@"521412386"];
  [item1 layoutIntoView];
  [self.universalWishList addObject:item4];
  
  // 1397504181
  
}

- (NSMutableArray*)retrieveWishesBy:(NSString*)userid {
  
  NSMutableArray *userWishes = [[NSMutableArray alloc] init];
  NSLog(@"Retrieve wishes for: %@", userid);
  NSLog(@"Number in universal: %d", [self.universalWishList count]);
  for (YSWishItem *item in self.universalWishList) {
    NSLog(@"item owner: %@ and name:%@", item.owner, item.name);
    if ([item.owner isEqualToString:userid]) {
      [userWishes addObject:item];
    }
  }
  NSLog(@"Number in matching: %d", [userWishes count]);
  return (NSMutableArray*)userWishes;
}

@end
