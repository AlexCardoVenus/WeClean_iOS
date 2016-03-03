//
//  ForgotSms.m
//  WeClean New
//
//  Created by Admin on 3/29/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "ForgotSms.h"
#import "WebService.h"
#import "Constants.h"
#import "SqliteDataBase.h"

@interface ForgotSms ()

@end

@implementation ForgotSms
UIActivityIndicatorView *indicator;

- (void)viewDidLoad {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.62 blue:0.56 alpha:1]; /*#01a2d6*/
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    [super viewDidLoad];
    btnReset.hidden=TRUE;
    btnVerify.hidden=FALSE;
    resetCode.hidden=TRUE;
    newPassword1.hidden=TRUE;
    newPassword2.hidden=TRUE;

}
- (UIBarButtonItem *)backBarButtonItem {
    UIImage *backImage = [UIImage imageNamed:@"backBtn.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 10, 30, 30);
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 7, 100, 30)];
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor whiteColor];
    label.text=@"WeClean";
    [self.navigationController.navigationBar addSubview:label];
    
    
    self.navigationItem.hidesBackButton = YES;
    return backBarButtonItem;
}
- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Reset:(id)sender {
    if (![verificationCode isEqualToString:resetCode.text]) {
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"])
        [self showAlert:@"Entered Code is Not Correct!!!"];
        else
            [self showAlert:@"進入 碼 是 不 正確!!!"];
    }
    else
    {
        if (![newPassword1.text isEqualToString:newPassword2.text]) {
            if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"])
            [self showAlert:@"Passwords does not match!!!"];
            else
                [self showAlert:@"密碼不正確!!!"];
        }
        else
        {
            NSString *pwsd;
            if ([newPassword1.text length]==0) {
                pwsd=@"pass1234";
            }
            else
            {
                pwsd=newPassword1.text;
            }
             [self showprogressbar];
   // NSError *error;
    NSString *postparm= [NSString stringWithFormat:@"&mobileno=%@&password=%@&FLAG=%@&",mobileNo.text,pwsd,@"change"];
//    WebService *webServ=[[WebService alloc]init];
//    NSData *data = [webServ postDataToServer:UPDATE_PSWD param:postparm];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:UPDATE_PSWD]];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            [request setHTTPBody:[[NSString stringWithFormat:postparm] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            
            
            
    if (data!=nil){
                NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSArray* itemsArray=[dataDict objectForKey:@"forgetpassword"];
                NSDictionary *dict=[itemsArray objectAtIndex:0];
                if ([[dict objectForKey:@"result"] isEqualToString:@"true"]) {
                    [self showAlert:@"Passwords Updated Succesfully"];
                    [indicator stopAnimating];
                }
            }
    else{
        
        
    }
        
        }];
            
        }}}

- (void) showAlert : (NSString *) msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:msg delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [alert show];
}
- (IBAction)verify:(id)sender {
     //[self showprogressbar];
    
    if ([self validateMobileNumberField]==TRUE) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        verificationCode = [defaults objectForKey:@"VerificationCode"];
        if ([verificationCode length]==0) {
            [defaults setObject:[NSString stringWithFormat:@"%d",100000] forKey:@"VerificationCode"];
        }
        else
        {
            [defaults setObject:[NSString stringWithFormat:@"%d",[verificationCode intValue]+1] forKey:@"VerificationCode"];
            
        }
        verificationCode = [defaults objectForKey:@"VerificationCode"];
        [self verifyCode];
        btnVerify.hidden=TRUE;
        resetCode.hidden=FALSE;
        newPassword1.hidden=FALSE;
        newPassword2.hidden=FALSE;
        btnReset.hidden=FALSE;
    }
    
    
}
-(Boolean)validateMobileNumberField
{
     [self showprogressbar];
    WebService *webServ=[[WebService alloc]init];
    NSData *data = [webServ postDataToServer:MOBILE_VERIFCN param:[NSString stringWithFormat:@"mobileno=%@",mobileNo.text]];
    NSError *error;
    if (data!=nil){
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray* itemsArray=[dataDict objectForKey:@"promocode"];
        NSDictionary *dict=[itemsArray objectAtIndex:0];
        if (![[dict objectForKey:@"result"] isEqualToString:@"true"]) {
            [indicator stopAnimating];
            return TRUE;
         }
    }
    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Mobile Number Not Exist!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"手機號碼 不 存在!!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
        [alert show];
    }
    
    return FALSE;
}
-(void)verifyCode{
  verificationCode=[self getRandomPINString:6];

  NSString *   message_text=[NSString stringWithFormat:@"Verification code is:%@",verificationCode];
    
    NSString *pwd=@"73837986";
    NSString *accno=@"11011956";
    
    NSString *verifyurl=[NSString stringWithFormat:MOBILE_Code@"&msg=%@&phone=%@&pwd=%@&accountno=%@",message_text,mobileNo.text,pwd,accno];
    NSString* encodedUrl = [verifyurl stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
 NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (dict1 !=NULL) {
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Verification code sent!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"驗證 碼 發送!!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
            [alert show];
        }
       
    }

}
-(NSString *)getRandomPINString:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    
    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    
    return returnString;
}

- (void)showSMS {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[mobileNo.text];
    NSString *message = [NSString stringWithFormat:@"Sent the verification code to your number. Please check %@", verificationCode];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (void) showprogressbar{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}
@end
