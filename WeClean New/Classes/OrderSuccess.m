//
//  OrderSuccess.m
//  WeClean New
//
//  Created by Admin on 3/23/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "OrderSuccess.h"
#import "WebService.h"
#import "Constants.h"
#import "PayPalMobile.h"
#import "ZZMainViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "OrderStatus.h"
#import "OrderFinish.h"

@interface OrderSuccess ()

@end

@implementation OrderSuccess
@synthesize orderNoStr,pickUpStr;
@synthesize totalItemStr,totalDueStr,deliveryto,deliverytime,Pickfrom,Picktime,customerID,specialRequest,itemArray,itemIDArray,itemColourArray,promoCode,itemCountArray,itemDetailsArray;
NSArray *_pickupfrom;
NSArray *_pickuptime;
UIActivityIndicatorView *indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setCustomNavigationBackButton];
    
    self.navigationItem.title = @"Schedule a pickup";
    orderNumber.text=[NSString stringWithFormat:@"Your Order ID is : %@",self.orderNoStr];
    pickupDetails.text=self.pickUpStr;
    totalItem.text=self.totalItemStr;
    totalDue.text=[self.totalDueStr stringByReplacingOccurrencesOfString:@"HK$" withString:@""];
    textFieldDeliveryTime.text=self.deliverytime;
    textFieldDeliveryTo.text =self.deliveryto;

    view1.layer.borderColor =  (__bridge CGColorRef)([UIColor colorWithRed:0.004 green:0.635 blue:0.839 alpha:1]);
    view1.layer.borderWidth = 1.0f;
    view1.layer.cornerRadius = 3.0f;
    view2.layer.borderColor = [UIColor grayColor].CGColor;
    view2.layer.borderWidth = 1.0f;
    view2.layer.cornerRadius = 3.0f;
    view3.layer.borderColor = [UIColor grayColor].CGColor;
    view3.layer.borderWidth = 1.0f;
    view3.layer.cornerRadius = 3.0f;
    
    btnConfirm.layer.cornerRadius = 5; // this value vary as per your desire
    btnConfirm.clipsToBounds = YES;
    btnPayLater.layer.cornerRadius = 5; // this value vary as per your desire
    btnPayLater.clipsToBounds = YES;
    btnPayNow.layer.cornerRadius = 5; // this value vary as per your desire
    btnPayNow.clipsToBounds = YES;
    
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
    }
 */
    order = [[OrderStatus alloc] initWithNibName:@"OrderStatus" bundle:nil];
    [[self navigationController] pushViewController:order animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}


-(void)postOrder
{
    [self showprogressbar];
    //HTTPPOST login
    NSMutableString *postparm;
//     postparm = [NSMutableString stringWithFormat:@"&deliveryto=%@&deliverytime=%@&Pickfrom=%@&Picktime=%@&CustomerID=%@&TotalDue=%@&actualDue=%@&SpecialRequest=%@&promoCode=%@&OrderID=%@&deliveryfee=%@&item[]=%@&itemid[]=%@&Itemcolor[]=%@",self.deliveryto,self.deliverytime,self.Pickfrom,self.Picktime,self.customerID,self.totalDueStr,self.totalDueStr,self.specialRequest,self.promoCode,self.orderNoStr,@"",self.itemArray,self.itemIDArray,self.itemColourArray];
    //promocode has some issue s
    postparm = [NSMutableString stringWithFormat:@"&deliveryto=%@&deliverytime=%@&Pickfrom=%@&Picktime=%@&CustomerID=%@&TotalDue=%@&actualDue=%@&SpecialRequest=%@&promoCode=%@&OrderID=%@&deliveryfee=%@&",self.deliveryto,self.deliverytime,self.Pickfrom,self.Picktime,self.customerID,self.totalDueStr,self.totalDueStr,self.specialRequest,self.promoCode,self.orderNoStr,@""];
    
    NSMutableArray *itemIDArrayColl=[[NSMutableArray alloc]init];
    for (int i=0; i<16; i++) {
        
        [itemIDArrayColl addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    for (int i=0; i<[itemIDArrayColl count]; i++) {
        NSString* itemID=[itemIDArrayColl objectAtIndex:i];
        int count=0;
        NSString *colorVal=@"select color";
        for (int j=0; j<[self.itemIDArray count]; j++) {
            if ([itemID intValue]==[[self.itemIDArray objectAtIndex:j]intValue]) {
                count=count+1;
                colorVal=[self.itemColourArray objectAtIndex:j];
            }
        }
        if (count>0) {
            [postparm appendString:[NSString stringWithFormat:@"item[]=%@&itemid[]=%@&Itemcolor[]=%@&",[NSString stringWithFormat:@"%d",count],[NSString stringWithFormat:@"%@",itemID],colorVal]];
        }
        
        
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ORDER_MODIFY]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:postparm] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data!=nil){
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *orderDeatils=[dataDict objectForKey:@"orderID"];
        NSDictionary *orderDeatilsDict=[orderDeatils objectAtIndex:0];
        
        if ( [[orderDeatilsDict objectForKey:@"result"]isEqualToString:@"true"]) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Updated Succesfully!"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     OrderFinish* finishController = [[OrderFinish alloc] initWithNibName:@"OrderFinish" bundle:nil];
                                     finishController.orderNoStr = self.orderNoStr;
                                     finishController.pickUpStr = self.pickUpStr;
                                     finishController.totalItemStr = self.totalItemStr;
                                     finishController.totalDueStr = self.totalDueStr;
                                     finishController.laundryAmountStr = self.laundryAmountStr;
                                     finishController.maleAmountStr = self.maleAmountStr;
                                     finishController.femaleAmountStr = self.femaleAmountStr;                                    
                                     [self.navigationController pushViewController:finishController animated:YES];
                                 }];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
        [indicator stopAnimating];
       
    }
        else{
            
            
        }
    }];
     }
-(IBAction)btnConfirm:(id)sender
{
   
        [self postOrder];
   
}
-(IBAction)btnPayLater:(id)sender
{
    OrderStatus *order;
/*    if ([[UIScreen mainScreen]bounds].size.height == 568||[[UIScreen mainScreen]bounds].size.height == 480)
    {
        order = [[OrderStatus alloc] initWithNibName:@"OrderStatus_4inch" bundle:nil];
    }*/
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

//change delivery details
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
    
    if (selectedTextField==textFieldDeliveryTo) {
        selectedText= [_pickupfrom objectAtIndex:row];
    }
    else if (selectedTextField==textFieldDeliveryTime)
    {
        selectedText= [_pickuptime objectAtIndex:row];
    }
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (selectedTextField==textFieldDeliveryTo) {
        return [_pickupfrom count];
    }
    else if (selectedTextField==textFieldDeliveryTime)
    {
        return [_pickuptime count];
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if (selectedTextField==textFieldDeliveryTo) {
        return [_pickupfrom objectAtIndex:row];
    }
    else if (selectedTextField==textFieldDeliveryTime)
    {
        return [_pickuptime objectAtIndex:row];
    }
    
    return @"";
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    [self showPicker:textFieldDeliveryTime];
    return YES;
}
-(void)doneClicked:(id)sender
{
    if ([selectedText length]==0) {
        if (selectedTextField==textFieldDeliveryTo) {
            selectedText= [_pickupfrom objectAtIndex:0];
        }
        else if (selectedTextField==textFieldDeliveryTime)
        {
            selectedText=  [_pickuptime objectAtIndex:0];
        }
    }
    selectedTextField.text=selectedText;
    selectedText=@"";
    [selectedTextField resignFirstResponder];
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
