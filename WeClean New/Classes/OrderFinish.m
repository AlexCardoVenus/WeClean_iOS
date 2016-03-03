//
//  OrderSuccess.m
//  WeClean New
//
//  Created by Admin on 3/23/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "OrderFinish.h"
#import "WebService.h"
#import "Constants.h"
#import "PayPalMobile.h"
#import "ZZMainViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "OrderStatus.h"
@interface OrderFinish ()

@end

@implementation OrderFinish
@synthesize orderNoStr,pickUpStr;
@synthesize totalItemStr,totalDueStr,deliveryto,deliverytime,Pickfrom,Picktime,customerID,specialRequest,itemArray,itemIDArray,itemColourArray,promoCode,itemCountArray,itemDetailsArray;
NSArray *_pickupfrom;
NSArray *_pickuptime;
UIActivityIndicatorView *indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavigationBackButton];
    
    self.navigationItem.title = @"Final";
    orderNumber.text=[NSString stringWithFormat:@"Your Order ID is : %@",self.orderNoStr];
    pickupDetails.text=self.pickUpStr;
    totalItem.text=self.totalItemStr;
    totalDue.text=[self.totalDueStr stringByReplacingOccurrencesOfString:@"HK$" withString:@""];

    btnPayLater.layer.cornerRadius = 5; // this value vary as per your desire
    btnPayLater.clipsToBounds = YES;
    btnPayNow.layer.cornerRadius = 5; // this value vary as per your desire
    btnPayNow.clipsToBounds = YES;
    
    laundryAmount.text = self.laundryAmountStr;
    maleAmount.text = self.maleAmountStr;
    femaleAMount.text = self.femaleAmountStr;
    
    _pickupfrom = @[@"In Person",@"Hang at door",@"Building security"];
    
    //init picktime array
    _pickuptime = @[@"anytime",@"9-10pm",@"10-11pm",@"11pm-12pm",@"12pm-6am",@"6-7am",@"7-8am"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setCustomNavigationBackButton
{
 
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backarow.png"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;

}


#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (void)goback {
    OrderStatus *order;
    /*
    if ([[UIScreen mainScreen]bounds].size.height == 568||[[UIScreen mainScreen]bounds].size.height == 480)
    {
        order = [[OrderStatus alloc] initWithNibName:@"OrderStatus_4inch" bundle:nil];
    }*/
    order = [[OrderStatus alloc] initWithNibName:@"OrderStatus" bundle:nil];
    [[self navigationController] pushViewController:order animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnPayLater:(id)sender
{
    OrderStatus *order;
/*
 if ([[UIScreen mainScreen]bounds].size.height == 568||[[UIScreen mainScreen]bounds].size.height == 480)
    {
        order = [[OrderStatus alloc] initWithNibName:@"OrderStatus_4inch" bundle:nil];
    }
*/
    order = [[OrderStatus alloc] initWithNibName:@"OrderStatus" bundle:nil];
    [[self navigationController] pushViewController:order animated:YES];
    
}
-(IBAction)btnPayNow:(id)sender
{
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AckjUBBGdxQ1vMhrCblXrZqcHtkDw9493bbZT_HYIA62Vtiu1qfmsEmfZ8Rh",
                                                           PayPalEnvironmentSandbox : @"AckjUBBGdxQ1vMhrCblXrZqcHtkDw9493bbZT_HYIA62Vtiu1qfmsEmfZ8Rh"}];
    ZZMainViewController *controler=[[ZZMainViewController alloc]init];
    controler.itemIDArray=self.itemIDArray;
    controler.itemArray=self.itemArray;
    controler.itemColourArray=self.itemColourArray;
    controler.itemCountArray=self.itemCountArray;
    controler.itemDetailsArray=self.itemDetailsArray;
    controler.totalCost=[self.totalDueStr stringByReplacingOccurrencesOfString:@"HK$" withString:@""];
    controler.orderID=self.orderNoStr;
    controler.customerID=self.customerID;
    [self.navigationController pushViewController:controler animated:YES];
    
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
