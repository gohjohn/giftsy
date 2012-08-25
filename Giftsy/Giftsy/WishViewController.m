//
//  WishViewController.m
//  Giftsy
//
//  Created by YangShun on 24/8/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "WishViewController.h"
#import "YSWishItem.h"
#import "AppDelegate.h"

#define kOFFSET_FOR_KEYBOARD 216.0

@interface WishViewController () 

@end

@implementation WishViewController

@synthesize wishImage;

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
  wishImageView.image = wishImage;
  [wishImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
  [wishImageView.layer setBorderWidth: 4.0];
  wishImageView.layer.shadowOffset = CGSizeMake(5, 5);
  wishImageView.layer.shadowRadius = 10;
  wishImageView.layer.shadowOpacity = 0.5;
  // Do any additional setup after loading the view from its nib.
}

- (void)backButtonPressed {
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardWillShow {
  // Animate the current view out of the way
  if (self.view.frame.origin.y >= 0)
  {
    [self setViewMovedUp:YES];
  }
  else if (self.view.frame.origin.y < 0)
  {
    [self setViewMovedUp:NO];
  }
}

-(void)keyboardWillHide {
  if (self.view.frame.origin.y >= 0)
  {
    [self setViewMovedUp:YES];
  }
  else if (self.view.frame.origin.y < 0)
  {
    [self setViewMovedUp:NO];
  }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
      [self setViewMovedUp:YES];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.25]; // if you want to slide up the view
  
  CGRect rect = self.view.frame;
  if (movedUp)
  {
    // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
    // 2. increase the size of the view so that the area behind the keyboard is covered up.
    rect.origin.y -= kOFFSET_FOR_KEYBOARD;
  }
  else
  {
    // revert back to the normal state.
    rect.origin.y += kOFFSET_FOR_KEYBOARD;
  }
  self.view.frame = rect;
  
  [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
  // unregister for keyboard notifications while not visible.
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)wishButtonPressed:(id)sender {
  
  AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
  
  YSWishItem *wishItem = [[YSWishItem alloc] initWithImage:self.wishImage
                                                      name:name.text
                                                     where:where.text
                                                     price:price.text
                                                      owner:appDelegate.userId];
  [wishItem layoutIntoView];
  NSLog(@"size of wish: %@", NSStringFromCGSize(wishItem.frame.size));
  [self.delegate addWishItem:wishItem];
  
  [self.navigationController popViewControllerAnimated:NO];
}

@end
