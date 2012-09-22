//
//  CheckOutViewController.h
//  DemoApps
//
//  Created by Tay Wenbin on 9/22/12.
//
//

#import <UIKit/UIKit.h>
#import "PayPal.h"


typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface CheckOutViewController : UIViewController <PayPalPaymentDelegate, UITextFieldDelegate>
{
@private
	UITextField *preapprovalField;
	CGFloat y;
	BOOL resetScrollView;
	PaymentStatus status;
}

-(void)loadItem:(NSString*)item Price:(int)price Qn:(int)qn;

@end



