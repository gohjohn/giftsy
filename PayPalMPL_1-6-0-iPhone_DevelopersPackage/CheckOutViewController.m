//
//  CheckOutViewController.m
//  DemoApps
//
//  Created by Tay Wenbin on 9/22/12.
//
//


#import "CheckOutViewController.h"
#import "PayPalPayment.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalAmounts.h"
#import "PayPalReceiverAmounts.h"
#import "PayPalAddress.h"
#import "PayPalInvoiceItem.h"

#define SPACING 3.


@interface CheckOutViewController ()
{
    IBOutlet UILabel *lblItem;
    IBOutlet UILabel *lblPrice;
    IBOutlet UILabel *lblQuantity;
    IBOutlet UILabel *lblTax;
    IBOutlet UILabel *lblTotal;
}
@end


@implementation CheckOutViewController


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
    
    [self loadItem:@"Something" Price:12345 Qn:2];
}


- (void)simplePayment {
	//dismiss any native keyboards
	[preapprovalField resignFirstResponder];
	
	//optional, set shippingEnabled to TRUE if you want to display shipping
	//options to the user, default: TRUE
	[PayPal getPayPalInst].shippingEnabled = TRUE;
	
	//optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
	//shipping and tax based on the user's address choice, default: FALSE
	[PayPal getPayPalInst].dynamicAmountUpdateEnabled = TRUE;
	
	//optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
	[PayPal getPayPalInst].feePayer = FEEPAYER_EACHRECEIVER;
	
	//for a payment with a single recipient, use a PayPalPayment object
	PayPalPayment *payment = [[[PayPalPayment alloc] init] autorelease];
	payment.recipient = @"example-merchant-1@paypal.com";
	payment.paymentCurrency = @"USD";
	payment.description = @"Teddy Bear";//TODO
	payment.merchantName = @"BeerPal";
	
	//subtotal of all items, without tax and shipping
	payment.subTotal = [NSDecimalNumber decimalNumberWithString:@"10"];//TODO
	
	//invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
	payment.invoiceData = [[[PayPalInvoiceData alloc] init] autorelease];
	payment.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithString:@"0.35"];
	
	//invoiceItems is a list of PayPalInvoiceItem objects
	//NOTE: sum of totalPrice for all items must equal payment.subTotal
	//NOTE: example only shows a single item, but you can have more than one
	payment.invoiceData.invoiceItems = [NSMutableArray array];
	PayPalInvoiceItem *item = [[[PayPalInvoiceItem alloc] init] autorelease];
	item.totalPrice = payment.subTotal;
	item.name = @"Teddy";
	[payment.invoiceData.invoiceItems addObject:item];
	
	[[PayPal getPayPalInst] checkoutWithPayment:payment];
}


-(void)loadItem:(NSString*)item Price:(int)price Qn:(int)qn{
    NSString *txtItem = [NSString stringWithFormat:@"Item: %@",item];
    NSString *txtPrice = [NSString stringWithFormat:@"Price: $%d:%d",price/100,price%100];
    
    NSString *txtQn = [NSString stringWithFormat:@"Quantity: %d",qn];
    
    int tax = 8 * qn * price / 100;
    NSString *txtTax = [NSString stringWithFormat:@"Tax: $%d:%d",tax/100,tax%100];
    
    int totalP = qn * price + tax;
    
    NSString *txtTotal = [NSString stringWithFormat:@"Total: $%d:%d",totalP/100,totalP%100];
    
    [lblItem setText:txtItem];
    [lblPrice setText:txtPrice];
    [lblQuantity setText:txtQn];
    [lblTax setText:txtTax];
    [lblTotal setText:txtTotal];
    
    UIButton *button = [[PayPal getPayPalInst] getPayButtonWithTarget:self andAction:@selector(simplePayment) andButtonType:BUTTON_294x43];
	CGRect frame = button.frame;
	frame.origin.x = 150;
	frame.origin.y = 200;
	button.frame = frame;
	[self.view addSubview:button];
    
}


- (void)viewDidUnload
{
    [lblItem release];
    lblItem = nil;
    [lblPrice release];
    lblPrice = nil;
    [lblQuantity release];
    lblQuantity = nil;
    [lblTax release];
    lblTax = nil;
    [lblTotal release];
    lblTotal = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)dealloc {
    [lblItem release];
    [lblPrice release];
    [lblQuantity release];
    [lblTax release];
    [lblTotal release];
    [super dealloc];
}


#pragma mark -
#pragma mark PayPalPaymentDelegate methods

-(void)RetryInitialization
{
    [PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX];
    
    //DEVPACKAGE
    //	[PayPal initializeWithAppID:@"your live app id" forEnvironment:ENV_LIVE];
    //	[PayPal initializeWithAppID:@"anything" forEnvironment:ENV_NONE];
}

//paymentSuccessWithKey:andStatus: is a required method. in it, you should record that the payment
//was successful and perform any desired bookkeeping. you should not do any user interface updates.
//payKey is a string which uniquely identifies the transaction.
//paymentStatus is an enum value which can be STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
	status = PAYMENTSTATUS_SUCCESS;
}

//paymentFailedWithCorrelationID is a required method. in it, you should
//record that the payment failed and perform any desired bookkeeping. you should not do any user interface updates.
//correlationID is a string which uniquely identifies the failed transaction, should you need to contact PayPal.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
    
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
	status = PAYMENTSTATUS_FAILED;
}

//paymentCanceled is a required method. in it, you should record that the payment was canceled by
//the user and perform any desired bookkeeping. you should not do any user interface updates.
- (void)paymentCanceled {
	status = PAYMENTSTATUS_CANCELED;
}

//paymentLibraryExit is a required method. this is called when the library is finished with the display
//and is returning control back to your app. you should now do any user interface updates such as
//displaying a success/failure/canceled message.
- (void)paymentLibraryExit {
	UIAlertView *alert = nil;
	switch (status) {
		case PAYMENTSTATUS_SUCCESS:
			
            
            
            
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            //SUCCESS!!!!!!!
            
            
            
            
            break;
		case PAYMENTSTATUS_FAILED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order failed"
											   message:@"Your order failed. Touch \"Pay with PayPal\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case PAYMENTSTATUS_CANCELED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order canceled"
											   message:@"You canceled your order. Touch \"Pay with PayPal\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
	}
	[alert show];
	[alert release];
}

//adjustAmountsForAddress:andCurrency:andAmount:andTax:andShipping:andErrorCode: is optional. you only need to
//provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
//for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
//the library will try to use the advanced version first, but will use this one if that one is not implemented.
- (PayPalAmounts *)adjustAmountsForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency andAmount:(NSDecimalNumber const *)inAmount
									andTax:(NSDecimalNumber const *)inTax andShipping:(NSDecimalNumber const *)inShipping andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
	//do any logic here that would adjust the amount based on the shipping address
	PayPalAmounts *newAmounts = [[[PayPalAmounts alloc] init] autorelease];
	newAmounts.currency = @"USD";
	newAmounts.payment_amount = (NSDecimalNumber *)inAmount;
	
	//change tax based on the address
	if ([inAddress.state isEqualToString:@"CA"]) {
		newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .1]];
	} else {
		newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .08]];
	}
	newAmounts.shipping = (NSDecimalNumber *)inShipping;
	
	//if you need to notify the library of an error condition, do one of the following
	//*outErrorCode = AMOUNT_ERROR_SERVER;
	//*outErrorCode = AMOUNT_CANCEL_TXN;
	//*outErrorCode = AMOUNT_ERROR_OTHER;
    
	return newAmounts;
}

//adjustAmountsAdvancedForAddress:andCurrency:andReceiverAmounts:andErrorCode: is optional. you only need to
//provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
//for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
//the library will try to use this version first, but will use the simple one if this one is not implemented.
- (NSMutableArray *)adjustAmountsAdvancedForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency
								 andReceiverAmounts:(NSMutableArray *)receiverAmounts andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
	NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:[receiverAmounts count]];
	for (PayPalReceiverAmounts *amounts in receiverAmounts) {
		//leave the shipping the same, change the tax based on the state
		if ([inAddress.state isEqualToString:@"CA"]) {
			amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .1]];
		} else {
			amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .08]];
		}
		[returnArray addObject:amounts];
	}
	
	//if you need to notify the library of an error condition, do one of the following
	//*outErrorCode = AMOUNT_ERROR_SERVER;
	//*outErrorCode = AMOUNT_CANCEL_TXN;
	//*outErrorCode = AMOUNT_ERROR_OTHER;
	
	return returnArray;
}




@end
