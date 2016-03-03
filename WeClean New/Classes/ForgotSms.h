//
//  ForgotSms.h
//  WeClean New
//
//  Created by Admin on 3/29/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface ForgotSms : UIViewController<MFMessageComposeViewControllerDelegate>
{
    __weak IBOutlet UITextField *mobileNo;
    __weak IBOutlet UITextField *resetCode;
    __weak IBOutlet UITextField *newPassword1;
    __weak IBOutlet UITextField *newPassword2;
    
    NSString *verificationCode;
    
    IBOutlet UIButton *btnVerify;
    IBOutlet UIButton *btnReset;
    
}
- (IBAction)Reset:(id)sender;
- (IBAction)verify:(id)sender;

@end
