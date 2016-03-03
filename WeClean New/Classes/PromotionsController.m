//
//  HelpViewController.m
//  WeClean New
//
//  Created by Never.SMile on 12/30/15.
//  Copyright © 2015 com.Jamhub. All rights reserved.
//

#import "PromotionsController.h"
#import "MFSideMenuContainerViewController.h"
#import "FirstViewController.h"
#import "SqliteDataBase.h"
#import "WebService.h"
#import "Constants.h"

@interface PromotionsController ()

@end

@implementation PromotionsController
UIActivityIndicatorView *indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
    self.navigationItem.title = @"Promotions";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.62 blue:0.56 alpha:1];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    customerid = [defaults objectForKey:@"customerid"];
    [self showCustomerDetails];
}

-(void)showCustomerDetails
{
    WebService *webServ=[[WebService alloc]init];
    NSData *data = [webServ postDataToServer:CUSTOMER_DETAILS param:[NSString stringWithFormat:@"CustomerID=%@",customerid]];
    NSError *error;
    if (data!=nil){
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray* itemsArray=[dataDict objectForKey:@"CustomerDetails"];
        NSDictionary *dict=[itemsArray objectAtIndex:0];
        firstName=[dict objectForKey:@"FirstName"];
        lastName=[dict objectForKey:@"LastName"];
        mobileNumber=[dict objectForKey:@"Mobile#1"];
        _referMobileNo.text=[dict objectForKey:@"Mobile#2"];
        address=[dict objectForKey:@"StreetAddress"];
        selectedDistID=[dict objectForKey:@"District"];
        emailID=[dict objectForKey:@"EmailAddress"];
        language=[dict objectForKey:@"Language"];
        password=[dict objectForKey:@"Password"];
        confirmPassword=[dict objectForKey:@"Password"];
        emailOrSms=[dict objectForKey:@"Notification"];
        selectedShopID=[dict objectForKey:@"ShopId"];
        randomRefCode=[dict objectForKey:@"refercode"];
    }
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

-(NSString*)getPasswordForEmptyPassword
{
    NSString *pwsd;
    if ([password length]==0) {
        pwsd=@"pass1234";
    }
    else
    {
        pwsd=password;
    }
    return pwsd;
}

- (IBAction)submitClicked:(id)sender {
    [self showprogressbar];
    NSString* promocode = @"";
    NSString *postparm= [NSString stringWithFormat:@"&CustomerID=%@&firstname=%@&lastname=%@&mobileno1=%@&mobileno2=%@&address=%@&district=%@&emailid=%@&language=%@&password=%@&notificationtype=%@&shopID=%@&randRefCode=%@&reference=%@&promocode=%@&",customerid,firstName,lastName,mobileNumber,_referMobileNo.text,address,selectedDistID,emailID,language,[self getPasswordForEmptyPassword],emailOrSms,selectedShopID,promocode,_referEmailId.text,promocode];
    NSLog(@"%@", postparm);
    //    WebService *webServ=[[WebService alloc]init];
    //    [webServ postDataToServer:MODIFY_CUSTOMER param:postparm];
    //    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:MODIFY_CUSTOMER]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:postparm] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError==nil){
            if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Updated Successfully..Your ReferenceCode is %@",randomRefCode] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"更新 成功..您的 參考 代碼 是 %@",randomRefCode] delegate:nil cancelButtonTitle:@"行" otherButtonTitles: nil];
                [alert show];
            }
            
            [indicator stopAnimating];
            [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMenuBarButtonItems {
    if(self.menuContainerViewController.menuState != MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
    [self rightBarButtonItem];
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
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil];
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
    return backBarButtonItem;}


- (UIBarButtonItem *)backBarButtonItem {
    UIImage *backImage = [UIImage imageNamed:@"menu-icon@2x.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 10, 30, 30);
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftSideMenuButtonPressed:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    
    self.navigationItem.hidesBackButton = YES;
    return backBarButtonItem;
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    
    else if([title isEqualToString:@"Cancel"]){
        
    }
}

-(FirstViewController *)getViewController
{
    FirstViewController *viewController;
    if ([[UIScreen mainScreen]bounds].size.height == 568)
    {
        viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    }
    else  if ([[UIScreen mainScreen]bounds].size.height == 480)
    {
        viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    }
    else
    {
        viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    }
    return viewController;
}

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
