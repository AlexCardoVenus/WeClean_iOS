//
//  SignupUserViewController.h
//  weclean
//
//  Created by Arun Rajkumar on 03/01/15.
//  Copyright (c) 2015 Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SignupUserViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *mobileNumber;
    IBOutlet UITextField *address;
    IBOutlet UITextField *district;
    IBOutlet UITextField *shop;
    IBOutlet UITextField *Verification_txtField;
    IBOutlet UIButton *Verify_Btn;
    IBOutlet UIView *Verify_View;
    
    IBOutlet UIScrollView *scrollView;
    NSArray *districtArray,*shopArray,*emailOrSmsArray,*languageArray;
    
    UITextField *selectedTextField;
    
    NSString *selectedText;
    NSString *selectedDistID;
    NSString *selectedShopID;
    UIButton *btnSubmit;
    UIButton *btnModify;
    UIButton *btnMore;
    
    BOOL *x;
    BOOL *y;
    
    //hidden fields
    
    __weak IBOutlet UITextField *emailID;
    
    __weak IBOutlet UITextField *password;
    
    __weak IBOutlet UITextField *confirmPassword;
    
    __weak IBOutlet UITextField *promoCode;
    
    __weak IBOutlet UITextField *emailOrSms;
    
    __weak IBOutlet UITextField *language;
    
    __weak IBOutlet UITextField *referMobileNo;
    
    __weak IBOutlet UITextField *referEmailId;
    __weak IBOutlet UILabel *emailNotVerified;
  
    __weak IBOutlet UILabel *labelReferToFriend;
    
    IBOutlet UILabel *clickToVerifyCodeLine;
    IBOutlet UIButton *clickoVerifyCodeButton;
    IBOutlet UIImageView *dropDown1;
    IBOutlet UIImageView *dropDown2;
    
    NSString *customerid;
    NSString *randomRefCode;
    
    
 
}
@property(nonatomic,assign)Boolean modifyOption;

-(IBAction)shopDetails:(id)sender;
-(IBAction)clickedBtnVerifyCode:(id)sender;

@end
