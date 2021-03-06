//
//  OrderSuccess.h
//  WeClean New
//
//  Created by Admin on 3/23/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFinish : UIViewController

{
    IBOutlet UILabel *orderNumber;
    IBOutlet UILabel *pickupDetails;
    IBOutlet UILabel *totalItem;
    IBOutlet UILabel *totalDue;
    IBOutlet UILabel *laundryAmount;
    IBOutlet UILabel *maleAmount;
    IBOutlet UILabel *femaleAMount;
    
    UITextField *selectedTextField;
    
    NSString *selectedText;
    
    IBOutlet UIButton *btnPayLater;
    IBOutlet UIButton *btnPayNow;
}

@property(nonatomic,retain)NSString *orderNoStr;
@property(nonatomic,retain)NSString *pickUpStr;
@property(nonatomic,retain)NSString *totalItemStr;
@property(nonatomic,retain)NSString *totalDueStr;
@property(nonatomic,retain)NSString *deliveryto;
@property(nonatomic,retain)NSString *deliverytime;
@property(nonatomic,retain)NSString *Pickfrom;
@property(nonatomic,retain)NSString *Picktime;
@property(nonatomic,retain)NSString *customerID;
@property(nonatomic,retain)NSString *specialRequest;
@property(nonatomic,retain)NSArray *itemArray;
@property(nonatomic,retain)NSArray *itemCountArray;
@property(nonatomic,retain)NSArray *itemIDArray;
@property(nonatomic,retain)NSArray *itemColourArray;
@property(nonatomic,retain)NSArray *itemDetailsArray;
@property(nonatomic,retain)NSString *promoCode;

@property(nonatomic,retain)NSString *laundryAmountStr;
@property(nonatomic,retain)NSString *maleAmountStr;
@property(nonatomic,retain)NSString *femaleAmountStr;

-(IBAction)btnPayLater:(id)sender;
-(IBAction)btnPayNow:(id)sender;



@end
