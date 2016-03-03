//
//  ViewController.m
//  WeClean New
//
//  Created by Admin on 3/15/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "OrderStatus.h"
#import "MFSideMenuContainerViewController.h"
#import "Web Service/WebService.h"
#import "ForgotSms.h"
#import "NSData+DataConnection.h"
#import "HomeViewController.h"
#import "OrderStatus.h"

@interface ViewController (){
    
    NSString *firstname;
    NSString *customerid;
}

@end

@implementation ViewController

UIActivityIndicatorView *indicator;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LoginClicked:(id)sender {
    [self showprogressbar];
    [self Dologin];
}
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}


- (IBAction)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}

- (IBAction)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void) Dologin
{
    
    NSString *userid =  self.userid.text;
    NSString *pwd =     self.password.text;
    NSString *postparm;
    
    if([pwd length] == 0){
        postparm = [NSString stringWithFormat:@"%@%@%@", @"mobileno1=", userid, @"&password=pass1234"];
    }
    else{
        postparm = [NSString stringWithFormat:@"%@%@%@%@", @"mobileno1=852", userid, @"&password=",pwd];
        //postparm = [NSString stringWithFormat:@"%@%@%@%@", @"mobileno1=", userid, @"&password=",pwd];
    }
    
    if([userid length] == 0){
        [self showValidationErr:(@"Please fill-in Mobile Number")];
    }
    else{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:LOGIN_URL]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithFormat:postparm] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
           if (data!=nil)
             {
            //success
            //initialize convert the received data to string with UTF8 encoding
            NSString *htmlSTR = [[NSString alloc] initWithData:data
                                                      encoding:NSUTF8StringEncoding];
            NSLog(@"Success:%@", htmlSTR);
            NSData *data = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *array = [json valueForKeyPath:@"firstname.FirstName"];
            NSArray *array1 = [json valueForKeyPath:@"firstname.CustomerID"];
                 if ([array1 class]==[NSNull class]) {
                      [self showValidationErr:@"Enter Correct Mobile Number and Password"];
                 }
                 else
                 {
            firstname = [[array valueForKey:@"description"] componentsJoinedByString:@""];
            customerid = [[array1 valueForKey:@"description"] componentsJoinedByString:@""];
            NSLog(@"Success:%@", customerid);
            
            //Store the customer id
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:customerid forKey:@"customerid"];
            [defaults setObject:firstname forKey:@"firstname"];
            [defaults synchronize];
            
                 UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                 NSArray *controllers;
                 
                
                     //HomeViewController *order;
                     HomeViewController *order;
                     
                      if ([[UIScreen mainScreen]bounds].size.height == 568||[[UIScreen mainScreen]bounds].size.height == 480)
                     {
//                         order = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                         order = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                     }
                     else
                     {
//                         order = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                         order = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                     }
                     
                     controllers = [NSArray arrayWithObject:order];
           
                
                 navigationController.viewControllers = controllers;
                 [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
             
        
                 }
                 }
           else
               
           {
               
               
           }
            
        }];
         
         
       [indicator stopAnimating];
    }
    
}

- (void) showValidationErr : (NSString *) msg{
    UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:msg delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [ErrorAlert show];
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


- (IBAction)forgotPassword:(id)sender {
    self.navigationController.navigationBarHidden=FALSE;
    ForgotSms *forgot;
    if ([[UIScreen mainScreen]bounds].size.height == 568||[[UIScreen mainScreen]bounds].size.height == 480)
    {
        forgot = [[ForgotSms alloc] initWithNibName:@"ForgotSms" bundle:nil];
    }
    else
    {
        forgot = [[ForgotSms alloc] initWithNibName:@"ForgotSms_6" bundle:nil];
    }
    [self.navigationController pushViewController:forgot animated:YES];
}


@end
