//
//  ZZMainViewController.h
//  PayPal-iOS-SDK-Sample-App
//
//  Copyright (c) 2014, PayPal
//  All rights reserved.
//

#import "ZZFlipsideViewController.h"
#import "PayPalMobile.h"

@interface ZZMainViewController : UIViewController <PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, ZZFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@property(nonatomic,retain)NSArray *itemArray;
@property(nonatomic,retain)NSArray *itemCountArray;
@property(nonatomic,retain)NSArray *itemIDArray;
@property(nonatomic,retain)NSArray *itemColourArray;
@property(nonatomic,retain)NSArray *itemDetailsArray;
@property(nonatomic,retain)NSString *totalCost;

@property(nonatomic,retain)NSString *customerID;
@property(nonatomic,retain)NSString *orderID;

@end
