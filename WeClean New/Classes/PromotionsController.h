//
//  PromotionsController.h
//  WeClean New
//
//  Created by Never.SMile on 12/30/15.
//  Copyright © 2015 com.Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionsController : UIViewController
{
    NSString* customerid;
    NSString* firstName;
    NSString* lastName;
    NSString* mobileNumber;
    NSString* address;
    NSString* selectedDistID;
    NSString* emailID;
    NSString* language;
    NSString* password;
    NSString* confirmPassword;
    NSString* emailOrSms;
    NSString* selectedShopID;
    NSString* randomRefCode;
}
@property (strong, nonatomic) IBOutlet UITextField *referMobileNo;
@property (strong, nonatomic) IBOutlet UITextField *referEmailId;
@end
