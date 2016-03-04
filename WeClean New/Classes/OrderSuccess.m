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
UIPickerView *pickerView ;
UIToolbar* toolbar;
@synthesize totalItemStr,totalDueStr,deliveryto,deliverytime,Pickfrom,Picktime,customerID,specialRequest,itemArray,itemIDArray,itemColourArray,promoCode,itemCountArray,itemDetailsArray;
NSArray *_pickupfrom;
NSArray *_pickuptime;
UIActivityIndicatorView *indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 310, 320, 200)];
    pickerView.dataSource=self;
    pickerView.delegate=self;
    [self setCustomNavigationBackButton];
    
    self.navigationItem.title = @"Schedule a pickup";
    orderNumber.text=[NSString stringWithFormat:@"Your Order ID is : %@",self.orderNoStr];
    pickupDetails.text=self.pickUpStr;
    totalItem.text=self.totalItemStr;
    totalDue.text=[self.totalDueStr stringByReplacingOccurrencesOfString:@"HK$" withString:@""];
    textFieldDeliveryTime.text=self.deliverytime;
    textFieldDeliveryTo.text =self.deliveryto;
    labelExpectedDate.text = self.expectedDateStr;

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
    order = [[OrderStatus alloc] initWithNibName:@"OrderStatus" bundle:nil];
    [[self navigationController] pushViewController:order animated:YES];
}


-(void)postOrder:(NSString*)orderStr
{
    [self showprogressbar];
    //HTTPPOST login
    NSMutableString *postparm;
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:orderStr]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:postparm] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data!=nil){
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *orderDeatils=[dataDict objectForKey:@"orderID"];
        NSDictionary *orderDeatilsDict=[orderDeatils objectAtIndex:0];
        if ( [[orderDeatilsDict objectForKey:@"result"]isEqualToString:@"true"]) {
            UIAlertController * alert;
            if([self.orderStr isEqualToString:ORDER_INSERT])
            {
                alert =   [UIAlertController
                           alertControllerWithTitle:@""
                           message:@"Created Succesfully!"
                           preferredStyle:UIAlertControllerStyleAlert];
            }
            else if ([self.orderStr isEqualToString:ORDER_MODIFY])
            {
                alert =   [UIAlertController
                           alertControllerWithTitle:@""
                           message:@"Updated Succesfully!"
                           preferredStyle:UIAlertControllerStyleAlert];
            }
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     OrderFinish* finishController = [[OrderFinish alloc] initWithNibName:@"OrderFinish" bundle:nil];
                                     finishController.orderNoStr = [orderDeatilsDict objectForKey:@"id"];
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
    [self postOrder: self.orderStr];
}

-(IBAction)dropDownClicked:(id)sender
{
    UIButton *aButton=sender;
    if (aButton.tag==101) {
        [self showPicker:textFieldDeliveryTo];
    }
    else if (aButton.tag==102) {
        [self showPicker:textFieldDeliveryTime];
    }
}
//change delivery details
//DropDown
- (IBAction)showPicker:(UITextField *)aTextField {
    
    [pickerView removeFromSuperview];
    toolbar.hidden=YES;
    CGSize rect = self.view.layer.frame.size;
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, rect.height - 200, rect.width, 200)];
    pickerView.backgroundColor=[UIColor whiteColor];
    //    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    toolbar = [[UIToolbar alloc] init];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, rect.height - 230, rect.width, 30)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    [self.view addSubview:toolbar];
    pickerView.hidden=NO;
    toolbar.hidden=NO;
    
    selectedTextField=aTextField;
    [self.view addSubview:pickerView];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
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
        textFieldDeliveryTo.text = selectedText;
    }
    else if (selectedTextField==textFieldDeliveryTime)
    {
        selectedText= [_pickuptime objectAtIndex:row];
        textFieldDeliveryTime.text = selectedText;
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

-(void)doneClicked:(id)sender
{
    [selectedTextField resignFirstResponder];
    
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
    [pickerView resignFirstResponder];
    [pickerView removeFromSuperview];
    toolbar.hidden=YES;
    pickerView.hidden=YES;
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
