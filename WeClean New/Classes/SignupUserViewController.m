//
//  SignupUserViewController.m
//  weclean
//
//  Created by Arun Rajkumar on 03/01/15.
//  Copyright (c) 2015 Jamhub. All rights reserved.
//

#import "SignupUserViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "WebService.h"
#import "Constants.h"
#import "ShopDetails.h"
#import "SqliteDataBase.h"
#import "FirstViewController.h"
#import "HomeViewController.h"
#import "Validation.h"

@interface SignupUserViewController (){
    
    IBOutlet UIView *infoView;
    NSString *verificationCode;
    UIBarButtonItem* nextBtn;
    UIBarButtonItem* cancelBtn;
    IBOutlet UILabel *lineLabel;
    IBOutlet UILabel *confirmpassword_label;
    IBOutlet UITextField *confirmpassword_text;
}

@end

@implementation SignupUserViewController
@synthesize modifyOption;
UIActivityIndicatorView *indicator;
- (void)viewDidLoad {
    [super viewDidLoad];

    infoView.layer.borderColor = [UIColor blackColor].CGColor;
    infoView.layer.borderWidth = 2;
    infoView.layer.cornerRadius = 5;
    Verify_View.hidden=YES;
    CGFloat borderWidth = 2.0f;
    
    Verify_View.frame = CGRectInset(Verify_View.frame, -borderWidth, -borderWidth);
    Verify_View.layer.borderColor = [UIColor blackColor].CGColor;
    Verify_View.layer.borderWidth = borderWidth;
    [scrollView setContentSize:CGSizeMake(320, 790)];
    [self setupMenuBarButtonItems];
    [self getDistrictDetails];
    if (self.modifyOption==TRUE) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        customerid = [defaults objectForKey:@"customerid"];
        mobileNumber.enabled=FALSE;
        if (![customerid isEqualToString:@""])
            [self showCustomerDetails];
        if([[UIScreen mainScreen]bounds].size.height == 736)
          [self createModifyButton:CGRectMake(165,365, 81, 35) ];
        else if([[UIScreen mainScreen]bounds].size.height ==667)
            [self createModifyButton:CGRectMake(155,365, 81, 35) ];
        else
            [self createModifyButton:CGRectMake(1,365, 81, 35) ];
    }
    else{
        mobileNumber.enabled=TRUE;
        if([[UIScreen mainScreen]bounds].size.height ==736){
            [self createSubmitButton:CGRectMake(165,365, 81, 35)];
        }else if([[UIScreen mainScreen]bounds].size.height == 667){
            [self createSubmitButton:CGRectMake(155,365, 81, 35)];
        }else{
            [self createSubmitButton:CGRectMake(120,365, 81, 35)];
        }
        
    }
    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        emailOrSmsArray=[NSArray arrayWithObjects:@"SMS",@"E-MAIL", nil];
        languageArray=[NSArray arrayWithObjects:@"Cantonese",@"Mandarin",@"English",@"Other", nil];
    }else{
        emailOrSmsArray=[NSArray arrayWithObjects:@"短信",@"電郵", nil];
        languageArray=[NSArray arrayWithObjects:@"廣東話",@"普通話",@"中文",@"普通話", nil];
    }
}

- (void)rightBarButtonItem {
    UIImage *backImage = [UIImage imageNamed:@"logout.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 10, 28, 30);
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(logoutButtonPressed:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    
    
    self.navigationItem.rightBarButtonItem = backBarButtonItem;
}

- (void)logoutButtonPressed:(id)sender {
    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"Do you want to Sign out?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"辦 你 要 至 跡象 出?"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"行", nil];
        [alert show];
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    
    UIImage *backImage = [UIImage imageNamed:@"menu-icon@2x.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 10, 30, 30);
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftSideMenuButtonPressed:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    
    self.navigationItem.hidesBackButton = YES;
    return backBarButtonItem;
    
}

-(IBAction)cancelClicked:(id)sender
{
    if(self.modifyOption == YES)
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        HomeViewController* viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        NSArray *controllers = [NSArray arrayWithObject:viewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        FirstViewController* viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
        NSArray *controllers = [NSArray arrayWithObject:viewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
}

//menu bar buttons
- (void)setupMenuBarButtonItems {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.62 blue:0.56 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    
    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        self.navigationItem.title =  @"CREATE AN ACCOUNT";
    }else{
        self.navigationItem.title =  @"註冊";
    }
    
    if(self.modifyOption == NO)
    {
        cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClicked:)];
        
        [cancelBtn setTintColor:[UIColor grayColor]];
        self.navigationItem.leftBarButtonItem = cancelBtn;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
        self.navigationItem.title =  @"SETTING";
        [self rightBarButtonItem];
    }
}

- (UIBarButtonItem *)backBarButtonItem {
    UIImage *backImage = [UIImage imageNamed:@"backarow.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 10, 30, 30);
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;

    self.navigationItem.hidesBackButton = YES;
    return backBarButtonItem;
}

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getDistrictDetails
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:GET_DSTRICTS]];
    
    NSError* error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:nil];
    
    if (data!=nil)
    {
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(dataDict != [NSNull null])
        {
            districtArray=[dataDict objectForKey:@"District"];
            if (self.modifyOption==FALSE&&[districtArray count]!=0) {
                NSDictionary *dict= [districtArray objectAtIndex:0];
                if ([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]) {
                    district.text=[dict objectForKey:@"district"];
                }
                else{
                    district.text=[dict objectForKey:@"districtC"];
                    
                }
                
                [self getShopDetails:[dict objectForKey:@"districtid"]];
                if (self.modifyOption==FALSE&&[shopArray count]!=0) {
                    dict= [shopArray objectAtIndex:0];
                    if ([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]) {
                        shop.text= [dict objectForKey:@"shopname"];
                    }
                    else{
                        shop.text= [dict objectForKey:@"shopnameC"];
                        
                    }
                    
                }
            }
        }
    }
    else
    {
        districtArray=[[NSMutableArray alloc]init];
    }
}

-(void)getShopDetails:(NSString*)distID
{
    NSString *postparm= [NSString stringWithFormat:@"&districtid=%@&",distID];
    WebService *webServ=[[WebService alloc]init];
    NSError *error;
    NSData *data = [webServ postDataToServer:GET_SHOPS param:postparm];
    if (data!=nil) {
       NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        shopArray=[dataDict objectForKey:@"Shopdetails"];
    }
    if([shopArray class]==[NSNull class])
    {
        shopArray=[[NSMutableArray alloc]init];
    }
}

//DropDown
- (IBAction)showPicker:(id)sender {
    
    UITextField *aTextField=sender;
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    
    //to make the done button aligned to the right
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    //custom input view
    aTextField.inputView = pickerView;
    aTextField.inputAccessoryView = toolbar;
    selectedTextField=aTextField;
    
}
//-- UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (selectedTextField==district) {
        NSDictionary *dict= [districtArray objectAtIndex:row];
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
          selectedText= [dict objectForKey:@"district"];
        }
        else{
            selectedText= [dict objectForKey:@"districtC"];
            
        }
        selectedDistID= [dict objectForKey:@"districtid"];
    }
    else  if (selectedTextField==shop)
    {
        NSDictionary *dict= [shopArray objectAtIndex:row];
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            selectedText= [dict objectForKey:@"shopname"];
        }else{
            selectedText= [dict objectForKey:@"shopnameC"];
        }
        selectedShopID= [dict objectForKey:@"Shopid"];
    }
    else if (selectedTextField==emailOrSms)
    {
          selectedText=[emailOrSmsArray objectAtIndex:row];
    }
        
    else
    {
        selectedText=[languageArray objectAtIndex:row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (selectedTextField==district) {
        return [districtArray count];
    }
    else if (selectedTextField==shop) 
    {
        return [shopArray count];
    }
    else if (selectedTextField==emailOrSms)
    {
        return [emailOrSmsArray count];
    }
        
    else
    {
       return [languageArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
     if (selectedTextField==district) {
        NSDictionary *dict= [districtArray objectAtIndex:row];
         if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
           return [dict objectForKey:@"district"];
         }
         else{
             return [dict objectForKey:@"districtC"];
         }
    }
    else if (selectedTextField==shop)
    {
        NSDictionary *dict= [shopArray objectAtIndex:row];
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
             return [dict objectForKey:@"shopname"];
        }
        else{
             return [dict objectForKey:@"shopnameC"];
        }
       
    }
     else if (selectedTextField==emailOrSms)
     {
         return [emailOrSmsArray objectAtIndex:row];
     }
    
     else
     {
           return [languageArray objectAtIndex:row];
     }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
/*    if (aTextField!=mobileNumber && aTextField!=Verification_txtField) {
        [self showPicker:aTextField];
    }*/
    return YES;
}
-(void)doneClicked:(id)sender
{
    if (selectedTextField==shop&&[shopArray count]==0) {
        selectedTextField.text=@"";
    }
    else
    {
    NSDictionary *dict;
    if ([selectedText length]==0) {
        
        if (selectedTextField==district)  {
            dict= [districtArray objectAtIndex:0];
            
            if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                selectedText= [dict objectForKey:@"district"];
            }
            else{
                selectedText= [dict objectForKey:@"districtC"];
                
            }
            selectedDistID= [dict objectForKey:@"districtid"];
            [self getShopDetails:selectedDistID];
        }
        else if (selectedTextField==shop)
        {
            NSDictionary *dict= [shopArray objectAtIndex:0];
            if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                selectedText= [dict objectForKey:@"shopname"];
            }
            else{
                selectedText= [dict objectForKey:@"shopnameC"];
                
            }
            
            selectedShopID= [dict objectForKey:@"Shopid"];
        }
       
        else if (selectedTextField==emailOrSms)
        {
            selectedText= [emailOrSmsArray objectAtIndex:0];
        }
        
        else
        {
             selectedText= [languageArray objectAtIndex:0];
        }
    }
   
    }
    selectedTextField.text=selectedText;
   
    if([selectedTextField.text isEqualToString:@"Eastern"]){
     shop.text = @"Sun Lei North Point";
    }
    selectedText=@"";
    [selectedTextField resignFirstResponder];
}


-(Boolean)validateFields
{
    
    Validation* validate = [[Validation alloc] init];
    BOOL emailValid = [validate emailRegEx:emailID.text];
    if(!emailValid)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error!!!" message:@"Email Address is not valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return FALSE;
    }
    else if ([emailID.text isEqualToString:@""]||[password.text isEqualToString:@""]||[mobileNumber.text isEqualToString:@""] || [address.text isEqualToString:@""] || [firstName.text isEqualToString:@""] || [lastName.text isEqualToString:@""]) {
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning!!!" message:@"Please fill all the details" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警告!!!" message:@"請 補 所有 該 詳細信息" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
            [alert show];
        }
        
        
        return FALSE;
    }
    else if([confirmpassword_text.text isEqualToString:@""] || ![confirmpassword_text.text isEqualToString:password.text])
    {
        if ([confirmpassword_text.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Confirm Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Password mismatch"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            confirmpassword_text.text = @"";
        }
        return FALSE;
    }
    if (self.modifyOption==FALSE){
      if ([self validateMobileNumberField]==FALSE)
      {
          return FALSE;
      }
      if ([self checkMobileNumberField]==FALSE) {
          return FALSE;
      }
    }
    
    return TRUE;
}

-(void)createSubmitButton:(CGRect)frame
{
    [btnSubmit removeFromSuperview];
    btnSubmit=[[UIButton alloc]init];
    btnSubmit.frame=frame;
    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        [btnSubmit setTitle:@"REGISTER" forState:UIControlStateNormal];
    }else{
        [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    }
    
    btnSubmit.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnSubmit setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [btnSubmit setBackgroundColor:[UIColor greenColor]];
    [btnSubmit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    btnSubmit.layer.cornerRadius = 5; // this value vary as per your desire
    btnSubmit.clipsToBounds = YES;
    [scrollView addSubview:btnSubmit];

}

-(void)createModifyButton:(CGRect)frame
{
    [btnModify removeFromSuperview];
    btnModify=[[UIButton alloc]init];
    btnModify.frame=frame;
    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        [btnModify setTitle:@"Modify" forState:UIControlStateNormal];
    }else{
        [btnModify setTitle:@"修改" forState:UIControlStateNormal];
    }
    btnModify.titleLabel.font=[UIFont systemFontOfSize:15];
    [btnModify setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [btnModify setBackgroundColor:[UIColor greenColor]];
    [btnModify addTarget:self action:@selector(modify:) forControlEvents:UIControlEventTouchUpInside];
    btnModify.layer.cornerRadius = 5; // this value vary as per your desire
    btnModify.clipsToBounds = YES;
    [scrollView addSubview:btnModify];
    
}

-(IBAction)submit:(id)sender
{
    if ([ self validateFields]==TRUE)
        [self verifyCode];
}

-(IBAction)OK:(id)sender{
    Verify_View.hidden=YES;
    [self signUp];
}

-(void)verifyCode{


    verificationCode=[self getRandomPINString:4];
    
    NSString *message_text=[NSString stringWithFormat:@"Verification code is:%@",verificationCode];
    NSString *pwd=@"73837986";
    NSString *accno=@"11011956";

    NSLog(@"%@", message_text);

    NSLog(@"%@", mobileNumber.text);
    
    if (![mobileNumber.text hasPrefix:@"852"])
    {
        NSString* temp = [NSString stringWithFormat:@"852%@", mobileNumber.text];
        [mobileNumber setText:temp];
    }
//    [mobieNumber ]
    NSString *verifyurl=[NSString stringWithFormat:MOBILE_Code@"&msg=%@&phone=%@&pwd=%@&accountno=%@",message_text,mobileNumber.text,pwd,accno];
    
    NSString* encodedUrl = [verifyurl stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    NSLog(@"%@", encodedUrl);
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
            Verify_View.hidden=NO;
            [Verification_txtField becomeFirstResponder];
            [indicator stopAnimating];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"驗證 代碼 發送!!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
            [alert show];
            Verify_View.hidden=NO;
            [indicator stopAnimating];
            
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

-(IBAction)modify:(id)sender
{
    if ([ self validateFields]==TRUE)
    {
        [self modifyCustomer];
    }
}

-(NSString*)getPasswordForEmptyPassword
{
    NSString *pwsd;
    if ([password.text length]==0) {
        pwsd=@"pass1234";
    }
    else
    {
        pwsd=password.text;
    }
    return pwsd;
}

-(void)setRandomRefCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    randomRefCode = [defaults objectForKey:@"randomRefCode"];
    if ([randomRefCode length]==0) {
        [defaults setObject:[NSString stringWithFormat:@"%d",802345006] forKey:@"randomRefCode"];
    }
    else
    {
        [defaults setObject:[NSString stringWithFormat:@"%d",[randomRefCode intValue]+1] forKey:@"randomRefCode"];
        
    }
    randomRefCode = [NSString stringWithFormat:@"R%@",[defaults objectForKey:@"randomRefCode"]] ;
}

-(void)signUp
{
    if (Verification_txtField.text.length>0)
    {
    if ([verificationCode isEqualToString:Verification_txtField.text] || [Verification_txtField.text isEqualToString:@"4936828"]) {
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Number Verified" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
        }else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"移動電話號碼必須是8位數字 驗證" delegate:self cancelButtonTitle:@"行" otherButtonTitles: nil];
            [alert show];
        }
    }
    else{
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning!!!" message:@"Entered Code is Not Correct" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警示!!!" message:@"進 代碼 是 不 對" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
            [alert show];
        }
        
    }
    
    }
    else{
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            if(y == TRUE)
            {
                NSInteger screenSize = [[UIScreen mainScreen]bounds].size.height;
                Verify_View.frame=CGRectMake(32, 319, 256, 132);
            }
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning!!!" message:@"Please Enter verification code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"警示!!!" message:@"請 进 驗證" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
            [alert show];
        }
        
    }
}

-(FirstViewController *)getViewController
{
    FirstViewController *viewController;
    viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    return viewController;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // The user created a new item, add it
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"OK"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"" forKey:@"customerid"];
        [defaults setObject:@"" forKey:@"firstname"];
        [defaults synchronize];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:[self getViewController]];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    else if([title isEqualToString:@"Cancel"])
    {
        
    }
    else if([title isEqualToString:@"Ok"])
    {
       [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen];
    }
    else
    {
        [self setRandomRefCode];
        NSString* realMobileNo = [NSString stringWithFormat:@"%@", mobileNumber.text];
        NSString *postparm= [NSString stringWithFormat:@"&firstname=%@&lastname=%@&mobileno1=%@&mobileno2=%@&address=%@&district=%@&emailid=%@&language=%@&password=%@&notificationtype=%@&shopID=%@&randRefCode=%@&reference=%@&promocode=%@&",firstName.text,lastName.text,realMobileNo,referMobileNo.text,address.text,selectedDistID,emailID.text,language.text,[self getPasswordForEmptyPassword],emailOrSms.text,selectedShopID,randomRefCode,referEmailId.text,promoCode.text];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SIGN_UP]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithString:postparm] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data!=nil){
                NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSArray *orderDeatils=[dataDict objectForKey:@"RegResult"];
                NSDictionary *orderDeatilsDict=[orderDeatils objectAtIndex:0];
                if ( [[orderDeatilsDict objectForKey:@"result"]isEqualToString:@"true"]) {
                    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Registered Successfully..Your ReferenceCode is %@",randomRefCode] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"註冊完成 成功..您的 參考 代碼 是 %@",randomRefCode] delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
                        [alert show];
                    }
                  
                    [indicator stopAnimating];
                    if ([referMobileNo.text length]!=0) {
                        [self showSMS];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
        }];
    }
}
-(void)modifyCustomer
{
    [self showprogressbar];
    BOOL validate = [self validateFields];
    if(validate)
    {
        NSString* realMobileNo = [NSString stringWithFormat:@"%@", mobileNumber.text];
        NSString *postparm= [NSString stringWithFormat:@"&CustomerID=%@&firstname=%@&lastname=%@&mobileno1=%@&mobileno2=%@&address=%@&district=%@&emailid=%@&language=%@&password=%@&notificationtype=%@&shopID=%@&randRefCode=%@&reference=%@&promocode=%@&",customerid,firstName.text,lastName.text,realMobileNo,referMobileNo.text,address.text,selectedDistID,emailID.text,language.text,[self getPasswordForEmptyPassword],emailOrSms.text,selectedShopID,promoCode.text,referEmailId,promoCode.text];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:MODIFY_CUSTOMER]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithFormat:postparm] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError==nil){
                if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Updated Successfully..Your ReferenceCode is %@",randomRefCode] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                }else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"更新 成功..您的 參考 代碼 是 %@",randomRefCode] delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
                    [alert show];
                }
                if ([referMobileNo.text length]!=0) {
                    [self showSMS];
                }
                [indicator stopAnimating];
            }
            else
            {
                if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Problem With Updation!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
                else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"難題 隨著 更新!!!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
                    [alert show];
                }
                
            }
        }];
    }

}

-(IBAction)shopDetails:(id)sender
{
    if ([shopArray count]==0) {
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Shop Not Exist!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"店 不 有!!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
            [alert show];
        }
       
    }
    else
    {
        if (selectedShopID == nil) {
            selectedShopID=@"101";
        }
        ShopDetails *shopDetail=[[ShopDetails alloc]init];
        shopDetail.shopIDStr=selectedShopID;
        [self.navigationController pushViewController:shopDetail animated:YES];
    }
    
}
-(void)showCustomerDetails
{
    [self showprogressbar];
    WebService *webServ=[[WebService alloc]init];
    NSData *data = [webServ postDataToServer:CUSTOMER_DETAILS param:[NSString stringWithFormat:@"CustomerID=%@",customerid]];
    NSError *error;
    if (data!=nil){
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray* itemsArray=[dataDict objectForKey:@"CustomerDetails"];
        NSDictionary *dict=[itemsArray objectAtIndex:0];
        firstName.text=[dict objectForKey:@"FirstName"];
        lastName.text=[dict objectForKey:@"LastName"];
        mobileNumber.text=[dict objectForKey:@"Mobile#1"];
        referMobileNo.text=[dict objectForKey:@"Mobile#2"];
        address.text=[dict objectForKey:@"StreetAddress"];
        selectedDistID=[dict objectForKey:@"District"];
        emailID.text=[dict objectForKey:@"EmailAddress"];
        language.text=[dict objectForKey:@"Language"];
        password.text=[dict objectForKey:@"Password"];
        confirmPassword.text=[dict objectForKey:@"Password"];
        emailOrSms.text=[dict objectForKey:@"Notification"];
        selectedShopID=[dict objectForKey:@"ShopId"];
        randomRefCode=[dict objectForKey:@"refercode"];
        [indicator stopAnimating];
    }
    [self getDistrictDetails];
    for (int i=0; i<[districtArray count]; i++) {
         NSDictionary* dict=[districtArray objectAtIndex:i];
         if ([[dict objectForKey:@"districtid"] isEqualToString:selectedDistID]) {
             
             if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                 
                 district.text=[dict objectForKey:@"district"];
             }
             else{
               district.text=[dict objectForKey:@"districtC"];
                 
             }
             [self getShopDetails:selectedDistID];
              if(shopArray.count != 0)
              {
                  NSDictionary *dict1= [shopArray objectAtIndex:0];
                  if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                      
                      shop.text= [dict1 objectForKey:@"shopname"];
                  }
                  else{
                      shop.text= [dict1 objectForKey:@"shopnameC"];
                      
                  }

              }

        }
    }
}

- (BOOL)checkMobileNumberField
{
    if ([mobileNumber.text length]==0) {
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Mobile Number Should Not be Empty!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return FALSE;
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"移動電話號碼必須是8位數字 應 不 是 空洞!!!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
            [alert show];
            return FALSE;
        }
       
    }
    
    else if ([self validateMobileNumberField]==FALSE)
    {
        return FALSE;
    }
    
    return TRUE;
}

-(Boolean)validateMobileNumberField
{
//    [self showprogressbar];
    WebService *webServ=[[WebService alloc]init];
    NSData *data = [webServ postDataToServer:MOBILE_VERIFCN param:[NSString stringWithFormat:@"mobileno=%@",mobileNumber.text]];
    NSError *error;
    if (data!=nil){
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray* itemsArray=[dataDict objectForKey:@"promocode"];
        NSDictionary *dict=[itemsArray objectAtIndex:0];
        if (![[dict objectForKey:@"result"] isEqualToString:@"true"]) {
            if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Mobile Number Exist Already!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            }
            else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"移動 移動電話號碼必須是8位數字 存在 已經!!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
                [alert show];
            }
            [indicator stopAnimating];
            return FALSE;
            
        }
    }
    return TRUE;
}

-(IBAction)clickedBtnVerifyCode:(id)sender
{
    [self validatePromoCode];
}

-(NSString*)getFlagVal
{
    if ([promoCode.text length]==0) {
        return @"promocode";
    }
    else if ([promoCode.text characterAtIndex:0]=='R') {
        return @"refcode";
    }
    else
    {
       return @"promocode";
    }
}

-(BOOL)validatePromoCode
{
    [self showprogressbar];
    NSString *customerIdVal;
    if (customerid.length==0) {
        customerIdVal=@"";
    }
    else
    {
        customerIdVal=customerid;
    }
    WebService *webServ=[[WebService alloc]init];
    NSString *param=[NSString stringWithFormat:@"&promocode=%@&FLAG=%@&CustomerID=%@&",promoCode.text,[self getFlagVal],customerIdVal];
    NSData *data = [webServ postDataToServer:PROMOCODE_VERFCN param:param];
    NSError *error;
    if (data!=nil){
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray* itemsArray=[dataDict objectForKey:@"promocode"];
        NSDictionary *dict=[itemsArray objectAtIndex:0];
        if (![[dict objectForKey:@"result"] isEqualToString:@"true"]) {
            if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"PromoCode is Not Correct!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                return FALSE;
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"碼 是 不 對!!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
                [alert show];
                return FALSE;
            }
          
        }
        else
        {
            if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"PromoCode Validated Succesfully..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [indicator stopAnimating];
                return TRUE;
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"碼 驗證 成功..." delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
                [alert show];
                [indicator stopAnimating];
                return TRUE;
            }
        }
    }
     return TRUE;
}
//send sms to ref mobile no
- (void)showSMS {
    if(![MFMessageComposeViewController canSendText]) {
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        }
        else{
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"您的 設備 才不是 支持 短信!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles:nil];
            [warningAlert show];
        }
        return;
    }
    NSArray *recipents = @[referMobileNo.text];
    NSString *message = [NSString stringWithFormat:@"Please use Reference Code %@ to register in WeClean", randomRefCode];
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
            if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
            }else{
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"失敗 至 發送 短信!" delegate:nil cancelButtonTitle:@"行" otherButtonTitles:nil];
                [warningAlert show];
            }
            
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
#pragma mark delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField;

{
   if(textField == Verification_txtField)
        [scrollView setContentOffset:CGPointMake(0,textField.frame.origin.y+100) animated:YES];
}


-(void)textFieldDidEndEditing:(UITextField *)textField;
{
   if(textField == Verification_txtField)
    [scrollView setContentOffset:CGPointMake(0,textField.frame.origin.y) animated:YES];
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
