//
//  ZZMainViewController.m
//  PayPal-iOS-SDK-Sample-App
//
//  Copyright (c) 2014, PayPal
//  All rights reserved.
//

#import "ZZMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZZFlipsideViewController.h"
#import "Constants.h"
#import "WebService.h"
#import "ViewController.h"

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@interface ZZMainViewController ()

@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payFutureButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation ZZMainViewController
@synthesize itemArray,itemCountArray,itemColourArray,itemIDArray,totalCost,itemDetailsArray;
@synthesize customerID,orderID;


- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //  [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction :@"YOUR_CLIENT_ID_FOR_PRODUCTION",PayPalEnvironmentSandbox : @"YOUR_CLIENT_ID_FOR_SANDBOX"}];
  // Set up payPalConfig
  _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
    _payPalConfig.acceptCreditCards = YES;
#else
    _payPalConfig.acceptCreditCards = NO;
#endif
  _payPalConfig.merchantName = @"WeClean";
  _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
  _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
  _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
  _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;

  // Do any additional setup after loading the view, typically from a nib.

  self.successView.hidden = YES;
  
  // use default environment, should be Production in real life
  self.environment = kPayPalEnvironment;

  NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
    

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  // Preconnect to PayPal early
  [self setPayPalEnvironment:self.environment];
}

- (void)setPayPalEnvironment:(NSString *)environment {
  self.environment = environment;
  [PayPalMobile preconnectWithEnvironment:environment];
}

#pragma mark - Receive Single Payment

- (IBAction)pay {
  // Remove our last completed payment, just for demo purposes.
  self.resultText = nil;
     NSMutableArray *itemsToPay=[[NSMutableArray alloc]init];
    for (int i=0; i<[self.itemCountArray count]; i++) {
        if ([[self.itemCountArray objectAtIndex:i]intValue]!=0) {
            NSDictionary *dict=[self.itemDetailsArray objectAtIndex:i];
            PayPalItem *item = [PayPalItem itemWithName:[dict objectForKey:@"ItemName"]
                                            withQuantity:[[self.itemCountArray objectAtIndex:i]intValue]
                                               withPrice:[[NSDecimalNumber alloc] initWithString:[dict objectForKey:@"Price"]]
                                            withCurrency:@"USD"
                                                 withSku:[dict objectForKey:@"ItemID"]];
            [itemsToPay addObject:item];
        }
       
    }
  
  NSDecimalNumber *subtotal = [[NSDecimalNumber alloc]initWithString:self.totalCost];
  
  // Optional: include payment details
  NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
  NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
  PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                             withShipping:shipping
                                                                                  withTax:tax];

  NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
  
  PayPalPayment *payment = [[PayPalPayment alloc] init];
  payment.amount = total;
  payment.currencyCode = @"USD";
  payment.shortDescription = @"WeClean Payment";
  payment.items = nil;  // if not including multiple items, then leave payment.items as nil
  payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil

  if (!payment.processable) {
      NSLog(@"can't process");
}
 //ViewController* viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
  self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
  //  ZZFlipsideViewController* flipViewController = [[ZZFlipsideViewController alloc] initWithNibName:@"ZZFlipsideViewController" bundle:nil];
  [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSString *postparm = [NSString stringWithFormat:@"&OrderID=%@&CustomerID=%@&",self.orderID,self.customerID];
    WebService *webServ=[[WebService alloc]init];
    [webServ postDataToServer:INSERT_PAYPAL param:postparm];
    [self showAlert:@"PayPal Payment Success!"];
    
  self.resultText = [completedPayment description];
  [self showSuccess];

  [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    [self showAlert:@"PayPal Payment Canceled"];
  self.resultText = nil;
  self.successView.hidden = YES;
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
  // TODO: Send completedPayment.confirmation to server
    [self showAlert:[NSString stringWithFormat:@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation]];
}


#pragma mark - Authorize Future Payments

- (IBAction)getUserAuthorizationForFuturePayments:(id)sender {
  
  PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
  [self presentViewController:futurePaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    [self showAlert:@"PayPal Future Payment Authorization Success!"];
  self.resultText = [futurePaymentAuthorization description];
  [self showSuccess];

  [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
     [self showAlert:@"PayPal Future Payment Authorization Canceled"];
  self.successView.hidden = YES;
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
  // TODO: Send authorization to server
    [self showAlert:[NSString stringWithFormat:@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization]];

}


#pragma mark - Authorize Profile Sharing

- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
  
  NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
  
  PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:self.payPalConfig delegate:self];
  [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    [self showAlert:@"PayPal Profile Sharing Authorization Success!"];
  self.resultText = [profileSharingAuthorization description];
  [self showSuccess];
  
  [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    [self showAlert:@"PayPal Profile Sharing Authorization Canceled"];
  self.successView.hidden = YES;
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
  // TODO: Send authorization to server
    [self showAlert:[NSString stringWithFormat:@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization]];
}


#pragma mark - Helpers

- (void)showSuccess {
  self.successView.hidden = NO;
  self.successView.alpha = 1.0f;
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.5];
  [UIView setAnimationDelay:2.0];
  self.successView.alpha = 0.0f;
  [UIView commitAnimations];
}

#pragma mark - Flipside View Controller
//settings open page
-(IBAction)settings:(id)sender
{
    ZZFlipsideViewController *cntrlr=[[ZZFlipsideViewController alloc]init];
    //[self presentViewController:cntrlr animated:YES completion:nil];
    cntrlr.delegate = self;
    [self.navigationController pushViewController:cntrlr animated:YES];
}

- (void) showAlert : (NSString *) msg{
    UIAlertView *showAlert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:msg delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [showAlert show];
}

@end
