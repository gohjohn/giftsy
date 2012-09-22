//
//  CheckViewController.h
//  BeerPal
//
//  Created by YangShun on 22/9/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPal.h"


typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface CheckViewController : UIViewController <PayPalPaymentDelegate, UITextFieldDelegate>
{
@private
	UITextField *preapprovalField;
	CGFloat y;
	BOOL resetScrollView;
	PaymentStatus status;
  NSString *_item;
  int _price;
  NSString *_quantity;
  NSString *txtTotal;
}

-(void)loadItem:(NSString*)item Price:(int)price Qn:(int)qn;

@end
