//
//  PlaceOrder.m
//  weclean
//
//  Created by Arun Rajkumar on 22/01/15.
//  Copyright (c) 2015 Jamhub. All rights reserved.
//

#import "PlaceOrder.h"
#import "MFSideMenuContainerViewController.h"
#import "PlaceOrderCustomCell.h"
#import "WebService.h"
#import "Constants.h"
#import "OrderSuccess.h"
#import "OrderStatus.h"
#import "SqliteDataBase.h"
#import "FirstViewController.h"

@interface PlaceOrder ()
@property (strong, nonatomic) IBOutlet UIButton *malebtn;
@property (strong, nonatomic) IBOutlet UIButton *femalebtn;
@property (strong, nonatomic) IBOutlet UIButton *laundrybtn;
@property (strong, nonatomic) IBOutlet UIButton *othersbtn;
@property (strong, nonatomic) IBOutlet UILabel *laundryAmount;
@property (strong, nonatomic) IBOutlet UILabel *maleAmount;
@property (strong, nonatomic) IBOutlet UILabel *femaleAmount;
@property (strong, nonatomic) IBOutlet UILabel *addedCount;
@end

@implementation PlaceOrder
@synthesize openingSection;
NSArray *_pickupfrom;
NSArray *_pickuptime;
UIPickerView *pickerView ;
UIToolbar* toolbar;
UIActivityIndicatorView *indicator;
NSInteger filterBtn;
@synthesize orderNoStr,pickUpStr;
@synthesize totalDueStr,deliveryto,deliverytime,Pickfrom,Picktime,customerID,specialRequest,itemArray,itemIDArray,itemColourArray,discountVal,promoCodeVal,itemsCountArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
    
    estimatedDue = [[UILabel alloc] init];
    estimatedDue.text = @"0";
    
    filterBtn = 0;
    uitableViewBorder.layer.borderColor = [UIColor grayColor].CGColor;
    uitableViewBorder.layer.borderWidth = 1.0f;
    textFieldDeliveryTime.layer.borderColor = [UIColor grayColor].CGColor;
    textFieldDeliveryTime.layer.borderWidth = 1.0f;
    textFieldDeliveryTime.layer.cornerRadius = 3.0f;
    textFieldDeliveryTo.layer.borderColor = [UIColor grayColor].CGColor;
    textFieldDeliveryTo.layer.borderWidth = 1.0f;
    textFieldDeliveryTo.layer.cornerRadius = 3.0f;
    textFieldPickupFrom.layer.borderColor = [UIColor grayColor].CGColor;
    textFieldPickupFrom.layer.borderWidth = 1.0f;
    textFieldPickupFrom.layer.cornerRadius = 3.0f;
    textFieldPickupTime.layer.borderColor = [UIColor grayColor].CGColor;
    textFieldPickupTime.layer.borderWidth = 1.0f;
    textFieldPickupTime.layer.cornerRadius = 3.0f;
    textFieldSpecialRequest.layer.borderColor = [UIColor grayColor].CGColor;
    textFieldSpecialRequest.layer.borderWidth = 1.0f;
    textFieldSpecialRequest.layer.cornerRadius = 3.0f;
    btnPlaceOrder.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithRed:0.004 green:0.635 blue:0.839 alpha:1]);
    btnPlaceOrder.layer.borderWidth = 1.0f;
    btnPlaceOrder.layer.cornerRadius = 3.0f;
    costViewBorder.layer.borderColor = [UIColor grayColor].CGColor;
    costViewBorder.layer.borderWidth = 1.0f;
       
    saveItemsArray=[[NSMutableArray alloc]init];
    saveItemsIDArray=[[NSMutableArray alloc]init];
    saveItemsColoursArray=[[NSMutableArray alloc]init];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.62 blue:0.56 alpha:1];
    self.navigationItem.title = @"Home";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
   
    if ([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]) {
        self.navigationItem.title =  @"Home";
    }
    else{
        self.navigationItem.title =  @"时间表 一个 拾起";
    }
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 310, 320, 200)];
    pickerView.dataSource=self;
    pickerView.delegate=self;
    //init pickfrom array
    coloursArray=@[[UIColor whiteColor],[UIColor grayColor],[UIColor blackColor],[UIColor magentaColor]/*pink*/,[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor]/*light green*/,[UIColor greenColor],[UIColor cyanColor]/*light blue color*/,[UIColor blueColor],[UIColor purpleColor]];
    if ([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]) {
    _pickupfrom = @[@"In Person",@"Hang at door",@"Building security"];
    
    //init picktime array
    _pickuptime = @[@"anytime",@"9-10pm",@"10-11pm",@"11pm-12pm",@"12pm-6am",@"6-7am",@"7-8am"];
    
    textFieldPickupFrom.text=@"In Person";
    textFieldDeliveryTo.text=@"In Person";
    textFieldPickupTime.text=@"anytime";
    textFieldDeliveryTime.text=@"anytime";
        colourNameArray=@[@"white",@"gray",@"black",@"pink",@"red",@"orange",@"yellow",@"light green",@"green",@"light blue",@"blue",@"purple"];
    
       }
    else{
        _pickupfrom = @[@"送到我家",@"貨掛在我家門口",@"送到大廈管理處"];
        
        //init picktime array
        _pickuptime = @[@"任何時段",@"9-10pm",@"10-11pm",@"11pm-12pm",@"12pm-6am",@"6-7am",@"7-8am"];
        
        textFieldPickupFrom.text=@"送到我家";
        textFieldDeliveryTo.text=@"送到我家 ";
        textFieldPickupTime.text=@"任何時段";
        textFieldDeliveryTime.text=@"任何時段";
        colourNameArray=@[@"白",@"灰",@"皂",@"粉红",@"红色",@"橙",@"黄",@"蔥綠",@"绿",@"淺藍",@"藍色",@"紫"];
       
    }
    
   //tableview part
    if ([self.customerID length]==0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        customerid = [defaults objectForKey:@"customerid"];
        btnDeleteOrder.hidden=TRUE;
        btnModifyOrder.hidden=TRUE;
        btnPlaceOrder.hidden=FALSE;
    }
    else
    {
        customerid=self.customerID;
        estimatedDue.text= self.totalDueStr;
        totalEstimate.text= self.totalDueStr;
        textFieldDeliveryTo.text=self.deliveryto;
        textFieldDeliveryTime.text=self.deliverytime;
        textFieldPickupFrom.text=self.Pickfrom;
        textFieldPickupTime.text=self.Picktime;
        textFieldSpecialRequest.text=self.specialRequest;
        saveItemsIDArray=[NSMutableArray arrayWithArray:self.itemIDArray];
        saveItemsColoursArray=[NSMutableArray arrayWithArray:self.itemColourArray];
        saveItemsArray=[NSMutableArray arrayWithArray:self.itemArray];
        totalItems.text=[NSString stringWithFormat:@"%lu",(unsigned long)[self.itemArray count]];
        btnDeleteOrder.hidden=FALSE;
        btnModifyOrder.hidden=FALSE;
        btnPlaceOrder.hidden=TRUE;
    }
    
}
-(NSInteger)calcAmount: (NSInteger)input
{
    NSInteger sum = 0;
    NSInteger maleID[] = {1, 3, 4, 6, 9, 13};
    NSInteger femaleID[] = {2, 5, 11, 14};
    NSInteger laundryID = 7;
    if (input == 1)
    {
        for (int i = 0; i < 6; i++) {
            NSInteger index = maleID[i] - 1;
            NSString* temp = [showItemCountArray objectAtIndex:index];
            sum += temp.integerValue;
        }
    }
    else if (input == 2)
    {
        for (int i = 0; i < 4; i++) {
            NSInteger index = femaleID[i] - 1;
            NSString* temp = [showItemCountArray objectAtIndex:index];
            sum += temp.integerValue;
        }
   
    }
    else if (input == 3)
    {
        NSInteger index = laundryID - 1;
        NSString* temp = [showItemCountArray objectAtIndex:index];
        sum += temp.integerValue;
    }
    return sum;
}

-(void)getDiscount
{
    //[self showprogressbar];
    NSString *postparm = [NSString stringWithFormat:@"%@%@", @"CustomerID=", customerid];
    WebService *webServ=[[WebService alloc]init];
    NSData *data = [webServ postDataToServer:GET_DISCOUNT param:postparm];
    NSError *error;
    if (data!=nil){
        //success
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *anArray=[dataDict objectForKey:@"disc"];
        NSDictionary *dict=[anArray objectAtIndex:0];
        self.discountVal=[dict objectForKey:@"Discount"];
        self.promoCodeVal=[dict objectForKey:@"promoCode"];
         [indicator stopAnimating];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showprogressbar];
    NSString *postparm = [NSString stringWithFormat:@"%@%@", @"CustomerID=", @"155"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ITEM_COST_URL]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:postparm] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"called");
        if (data!=nil){
            //success
            [indicator stopAnimating];
            NSDictionary *dataDict = [[NSDictionary alloc] init];
            dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if(dataDict != [NSNull null])
            {
                itemsArray=[dataDict objectForKey:@"Itemcost"];
                showItemCountArray=[[NSMutableArray alloc]init];
                showItemColourArray=[[NSMutableArray alloc]init];
                for (int i=0; i<[itemsArray count]; i++) {
                    [showItemCountArray addObject:@"0"];
                    [showItemColourArray addObject:@"select color"];
                }
                for (int i=0; i<[saveItemsIDArray count]; i++) {
                    NSString *itemID=[saveItemsIDArray objectAtIndex:i];
                    for (int j=0; j<[itemsArray count]; j++) {
                        NSDictionary *dict=[itemsArray objectAtIndex:j];
                        if ([[dict objectForKey:@"ItemID"]isEqualToString:itemID]) {
                            [showItemCountArray replaceObjectAtIndex:j withObject:[itemsCountArray objectAtIndex:i]];
                            [showItemColourArray replaceObjectAtIndex:j withObject:[saveItemsColoursArray objectAtIndex:i]];
                            [saveItemsArray addObject:[dict objectForKey:@"ItemName"]];
                            
                        }
                        
                    }
                }
                
                [self updateAmount_Bucket];
               
            }
            
            [itemTableView  reloadData];
        }
        else{
            
        }
    }];
    if ([self.discountVal length]==0) {
        self.discountVal=@"";
        [self getDiscount];
    }
    
    if ([self.promoCodeVal length]==0) {
        self.promoCodeVal=@"";
    }
    
    if (openingSection==1) {
        openingSection=0;
        self.customerID=@"";
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        OrderStatus *order = [[OrderStatus alloc] initWithNibName:@"OrderStatus" bundle:nil];
        NSArray *controllers= [NSArray arrayWithObject:order];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if (openingSection==2)
    {
        openingSection=1;
        OrderSuccess *success=[self getSuccessView];
        success.orderNoStr=self.orderNoStr;
        success.pickUpStr=self.pickUpStr;
        success.totalDueStr=self.totalDueStr;
        success.deliveryto=self.deliveryto;
        success.deliverytime=self.deliverytime;
        success.Pickfrom=self.Pickfrom;
        success.Picktime=self.Picktime;
        success.customerID=self.customerID;
        success.specialRequest=self.specialRequest;
        success.itemArray=self.itemArray;
        success.itemIDArray=self.itemIDArray;
        success.itemColourArray=self.itemColourArray;
        success.totalItemStr=[NSString stringWithFormat:@"%lu",(unsigned long)[self.itemIDArray count]];

        success.laundryAmountStr = self.laundryAmountStr;
        success.maleAmountStr = self.maleAmountStr;
        success.femaleAmountStr = self.femaleAmountStr;
        
        [self.navigationController pushViewController:success animated:YES];
        
    }

}

//menu bar buttons

- (void)logoutButtonPressed:(id)sender {
    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"Do you want to Sign out?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Ok", nil];
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

- (void)setupMenuBarButtonItems {
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
    [self rightBarButtonItem];
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

- (void)rightBarButtonItem {
    UIImage *backImage = [UIImage imageNamed:@"logout.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 10, 28, 30);
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(logoutButtonPressed:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    
    
    self.navigationItem.rightBarButtonItem = backBarButtonItem;
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(backButtonPressed:)];
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
    // Dispose of any resources that can be recreated.
}

//tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if(filterBtn == 0)
    {
        count = [itemsArray count];
    }
    else if (filterBtn == 1)
    {
        count = 6;
    }
    else if (filterBtn == 2)
    {
        count = 4;
    }
    else if (filterBtn == 3)
    {
        count = 1;
    }
    else if (filterBtn == 4)
    {
        count = 4;
    }
    else
    {
        for(int i = 0 ; i < showItemCountArray.count; i ++)
        {
            NSString* str = [showItemCountArray objectAtIndex:i];
            if(str.floatValue > 0)
            {
                addedToCartArray[count] =  i + 1;
                count ++;
                
            }
        }
    }
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    PlaceOrderCustomCell *cell =(PlaceOrderCustomCell *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil){
        
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"PlaceOrderCustomCell" owner:nil options:nil];
        
        for(id currentObject in objs)
        {
            if([currentObject isKindOfClass:[PlaceOrderCustomCell class]])
            {
                cell = (PlaceOrderCustomCell *)currentObject;
                break;
            }
        }
    }
    NSInteger index = [self getID:indexPath.row];
    NSDictionary *dict = [itemsArray objectAtIndex:index];
   
    cell.labelSelectColour.text=[showItemColourArray objectAtIndex:index];
    if ([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]) {
        cell.itemName.text= [dict objectForKey:@"ItemName"];}
    else{
        cell.labelSelectColour.text=@"選色";
        
        [cell.btnAdd setTitle: @"加" forState: UIControlStateNormal];
        
        cell.itemName.text= [dict objectForKey:@"ItemNameChinese"];
        
    }
    cell.btnSelectColour.tag=indexPath.row;
    cell.btnAdd.tag=indexPath.row;
    cell.btnDeduct.tag=indexPath.row;
    
    cell.countLabel.text=[showItemCountArray objectAtIndex:index];
    [cell.btnSelectColour addTarget:self action:@selector(btnSelectColourClicked:) forControlEvents:UIControlEventTouchUpInside];
     [cell.btnAdd addTarget:self action:@selector(btnAddClicked:) forControlEvents:UIControlEventTouchUpInside];
     [cell.btnDeduct addTarget:self action:@selector(btnDeductClicked:) forControlEvents:UIControlEventTouchUpInside];
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://52.76.209.35/WeClean/images/%@",[dict objectForKey:@"itemImgName"]]];
                       //NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                       dispatch_sync(dispatch_get_main_queue(), ^{
//                           cell.itemImage.image = [UIImage imageWithData:imageData];
                           cell.itemImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [dict objectForKey:@"itemImgName"]]];
                       });
                   });
      cell.selectionStyle=UITableViewCellEditingStyleNone;
      return cell;
}



-(IBAction)btnSelectColourClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    [self setUpPopUpView:(int)btn.tag];
    
}
-(IBAction)btnAddClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    PlaceOrderCustomCell *cell = (PlaceOrderCustomCell*)[itemTableView cellForRowAtIndexPath:myIndex];
    cell.countLabel.text=[NSString stringWithFormat:@"%d",[cell.countLabel.text intValue]+1];
    NSString *estimatedDueStr=[estimatedDue.text stringByReplacingOccurrencesOfString:@"HK$" withString:@""];
    float due=[estimatedDueStr floatValue]+[[[itemsArray objectAtIndex:btn.tag]objectForKey:@"Price"]floatValue ];
    estimatedDue.text =[NSString stringWithFormat:@"HK$%.2f",due];
    totalEstimate.text =[NSString stringWithFormat:@"HK$%.2f",due];
    [saveItemsArray addObject:[[itemsArray objectAtIndex:btn.tag]objectForKey:@"ItemName"]];
    [saveItemsIDArray addObject:[[itemsArray objectAtIndex:btn.tag]objectForKey:@"ItemID"]];
    [saveItemsColoursArray addObject:cell.labelSelectColour.text];
    
    NSInteger index = [self getID:btn.tag];
    [showItemCountArray replaceObjectAtIndex:index withObject:cell.countLabel.text];
    totalItems.text=[NSString stringWithFormat:@"%lu",(unsigned long)[saveItemsIDArray count]];
    
    [self updateAmount_Bucket];
}

-(NSInteger) getID:(NSInteger)input
{
    NSInteger maleID[] = {1, 3, 4, 5, 9, 13};
    NSInteger femaleID[] = {2, 6, 11, 14};
    NSInteger laundryID = 7;
    NSInteger othersID[] = {8, 10, 12, 15};
    NSInteger index = input;
    switch(filterBtn)
    {
        case 1:
            index = maleID[index] - 1;
            break;
        case 2:
            index = femaleID[index] - 1;
            break;
        case 3:
            index = laundryID - 1;
            break;
        case 4:
            index = othersID[index] - 1;
            break;
        case 5:
            index = addedToCartArray[index] - 1;
            break;
    }
    return index;
}

-(IBAction)btnDeductClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    PlaceOrderCustomCell *cell = (PlaceOrderCustomCell*)[itemTableView cellForRowAtIndexPath:myIndex];
    if (![cell.countLabel.text isEqualToString:@"0"]) {
        cell.countLabel.text=[NSString stringWithFormat:@"%d",[cell.countLabel.text intValue]-1];
        NSString *estimatedDueStr=[estimatedDue.text stringByReplacingOccurrencesOfString:@"HK$" withString:@""];
        float due=[estimatedDueStr floatValue]-[[[itemsArray objectAtIndex:btn.tag]objectForKey:@"Price"]floatValue ];
        estimatedDue.text =[NSString stringWithFormat:@"HK$%.2f",due];
        totalEstimate.text =[NSString stringWithFormat:@"HK$%.2f",due];
        
        NSString *itemID=[[itemsArray objectAtIndex:btn.tag]objectForKey:@"ItemID"];
        int index=-1;
        for (int i=0; i<[saveItemsIDArray count]; i++) {
            if ([[saveItemsIDArray objectAtIndex:i] isEqualToString: itemID]) {
                index=i;
            }
        }
        if (index>=0) {
            [saveItemsArray removeObjectAtIndex:index];
            [saveItemsIDArray removeObjectAtIndex:index];
            [saveItemsColoursArray removeObjectAtIndex:index];
        }

    }
    if ([cell.countLabel.text isEqualToString:@"0"]) {
        if ([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]) {
        cell.labelSelectColour.text=@"select color";
        }
        else{
            
            cell.labelSelectColour.text=@"選色";
        }
    }
   
[showItemCountArray replaceObjectAtIndex:btn.tag withObject:cell.countLabel.text];
[showItemColourArray replaceObjectAtIndex:btn.tag withObject:cell.labelSelectColour.text];
totalItems.text=[NSString stringWithFormat:@"%lu",(unsigned long)[saveItemsIDArray count]];
    [self updateAmount_Bucket];

}

-(void) updateAmount_Bucket
{
    NSString* AmountStr = [NSString stringWithFormat:@"%ld",[self calcAmount:1]];
    _maleAmount.text = AmountStr;
    self.maleAmountStr = AmountStr;
    AmountStr = [NSString stringWithFormat:@"%ld",[self calcAmount:2]];
    _femaleAmount.text = AmountStr;
    self.femaleAmountStr = AmountStr;
    AmountStr = [NSString stringWithFormat:@"%ld",[self calcAmount:3]];
    _laundryAmount.text = AmountStr;
    self.laundryAmountStr = AmountStr;
    
    NSInteger sum = 0;
    for(int i = 0; i < showItemCountArray.count; i++)
    {
        NSString* temp = [showItemCountArray objectAtIndex:i];
        sum += temp.integerValue;
    }
    _addedCount.text = [NSString stringWithFormat:@"%ld", sum];
}
//popup colour buttons
-(void)setUpPopUpView:(int)mainTagVal
{
    colourView=[[UIView alloc]initWithFrame:CGRectMake(30, 150, 250, 190)];
    colourView.backgroundColor=[UIColor lightGrayColor];
    int count=0;
    float xVal=10;
    float yVal=10;
    for (int i=0; i<3; i++) {
        
        for (int j=0; j<4; j++) {
            [colourView addSubview:[self createColourButton:CGRectMake(xVal, yVal, 50, 50) tag:count+100 colour:[coloursArray objectAtIndex:count] mainTagVal:mainTagVal]];
            xVal=xVal+60;
            count=count+1;
        }
        xVal=10;
        yVal=yVal+60;
    }
    
    
    [self showAnimatePopUp];
    
}
- (void)showAnimatePopUp
{
    [self.view addSubview:colourView];
    colourView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    colourView.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        colourView.alpha = 1;
        colourView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        colourView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        colourView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [colourView removeFromSuperview];
        }
    }];
}

//clear colour buttons
-(UIButton *)createColourButton:(CGRect)frame tag:(int)tagVal colour:(UIColor*)colour mainTagVal:(int)mainTagVal
{
    UIButton *btn=[[UIButton alloc]init];
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=colour;
    [btn addTarget:self action:@selector(selectedColour:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag=tagVal;
    btn.frame=frame;
    mainTagValCopy=mainTagVal;
    return btn;
}
-(IBAction)selectedColour:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    [self removeAnimate];
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:mainTagValCopy inSection:0];
    PlaceOrderCustomCell *cell = (PlaceOrderCustomCell*)[itemTableView cellForRowAtIndexPath:myIndex];
    cell.labelSelectColour.text=[colourNameArray objectAtIndex:btn.tag-100];
    [showItemColourArray replaceObjectAtIndex:mainTagValCopy withObject:cell.labelSelectColour.text];
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
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
    
    if (selectedTextField==textFieldPickupFrom||selectedTextField==textFieldDeliveryTo) {
         selectedText= [_pickupfrom objectAtIndex:row];
        
    }
    else if (selectedTextField==textFieldPickupTime||selectedTextField==textFieldDeliveryTime)
    {
         selectedText= [_pickuptime objectAtIndex:row];
        
    }
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (selectedTextField==textFieldPickupFrom||selectedTextField==textFieldDeliveryTo) {
         return [_pickupfrom count];
    }
    else if (selectedTextField==textFieldPickupTime||selectedTextField==textFieldDeliveryTime)
    {
        return [_pickuptime count];
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if (selectedTextField==textFieldPickupFrom||selectedTextField==textFieldDeliveryTo) {
         selectedTextField.text=[_pickupfrom objectAtIndex:row];
         return [_pickupfrom objectAtIndex:row];
    }
    else if (selectedTextField==textFieldPickupTime||selectedTextField==textFieldDeliveryTime)
    {
        selectedTextField.text=[_pickuptime objectAtIndex:row];

         return [_pickuptime objectAtIndex:row];
    }
    
   return @"";
}

-(IBAction)dropDownClicked:(id)sender
{
     UIButton *aButton=sender;
    if (aButton.tag==101) {
         [self showPicker:textFieldPickupFrom];
    }
    else if (aButton.tag==102) {
        [self showPicker:textFieldPickupTime];
    }
    else if (aButton.tag==103) {
        [self showPicker:textFieldDeliveryTo];
    }
    else if (aButton.tag==104) {
        [self showPicker:textFieldDeliveryTime];
    }
}

-(void)doneClicked:(id)sender
{
    if ([selectedText length]==0) {
        if (selectedTextField==textFieldPickupFrom||selectedTextField==textFieldDeliveryTo) {
            selectedText= [_pickupfrom objectAtIndex:0];
            [selectedTextField resignFirstResponder];
            [pickerView resignFirstResponder];
            [pickerView removeFromSuperview];
            toolbar.hidden=YES;

            
        }
        else if (selectedTextField==textFieldPickupTime||selectedTextField==textFieldDeliveryTime)
        {
            selectedText=  [_pickuptime objectAtIndex:0];
            [selectedTextField resignFirstResponder];
            [pickerView resignFirstResponder];
            [pickerView removeFromSuperview];
            toolbar.hidden=YES;

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

-(IBAction)placeOrder:(id)sender
{
    if ([ self validateFields]==TRUE) {
        [self showprogressbar];
        if ([[totalEstimate.text stringByReplacingOccurrencesOfString:@"HK$" withString:@""]intValue]>200) {
            [self postOrder:ORDER_INSERT];
            if ([self.discountVal length]!=0 && self.discountVal.integerValue != 0) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"You will get a discount of HK$%@",self.discountVal] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                float due=[[estimatedDue.text stringByReplacingOccurrencesOfString:@"HK$" withString:@""]floatValue];
                estimatedDue.text=[NSString stringWithFormat:@"HK$%.2f",due-[self.discountVal floatValue]];
            }
             [indicator stopAnimating];
        }
        else{
            [self postOrder:ORDER_INSERT];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Delivery charge HK$20 will apply" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } }

}
- (IBAction)shoppingCartPressed:(id)sender {
    filterBtn = 5;
    [itemTableView reloadData];
}
-(IBAction)modifyOrder:(id)sender
{
   if ([ self validateFields]==TRUE) {
       [self showprogressbar];
       [self postOrder:ORDER_MODIFY];
   }
}
-(IBAction)deleteOrder:(id)sender
{
    [self showprogressbar];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];

}
-(void)postOrder:(NSString*)orderStr
{
    //HTTPPOST login
/*    NSMutableString *postparm= [NSMutableString stringWithFormat:@"&deliveryto=%@&deliverytime=%@&Pickfrom=%@&Picktime=%@&CustomerID=%@&TotalDue=%@&actualDue=%@&SpecialRequest=%@&promoCode=%@&OrderID=%@&deliveryfee=%@&",textFieldDeliveryTo.text,textFieldDeliveryTime.text,textFieldPickupFrom.text,textFieldPickupTime.text,customerid,[estimatedDue.text stringByReplacingOccurrencesOfString:@"HK$" withString:@""],[totalEstimate.text stringByReplacingOccurrencesOfString:@"HK$" withString:@""],textFieldSpecialRequest.text,self.promoCodeVal,orderNoStr,@""];
    NSMutableArray *itemIDArrayColl=[[NSMutableArray alloc]init];
      for (int i=0; i<[itemsArray count]; i++) {
          NSDictionary *dict=[itemsArray objectAtIndex:i];
          [itemIDArrayColl addObject:[dict objectForKey:@"ItemID"]];
      }
    for (int i=0; i<[itemIDArrayColl count]; i++) {
         NSString* itemID=[itemIDArrayColl objectAtIndex:i];
         int count=0;
         NSString *colorVal=@"select color";
         for (int j=0; j<[saveItemsIDArray count]; j++) {
        if ([itemID intValue]==[[saveItemsIDArray objectAtIndex:j]intValue]) {
            count=count+1;
            colorVal=[saveItemsColoursArray objectAtIndex:j];
        }
         }
        if (count>0) {
            NSString* append = [NSString stringWithFormat:@"item[]=%@&itemid[]=%@&Itemcolor[]=%@&",[NSString stringWithFormat:@"%d",count],[NSString stringWithFormat:@"%@",itemID],colorVal];
             [postparm appendString:append];
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
        
        if ( [[orderDeatilsDict objectForKey:@"result"]isEqualToString:@"true"]) {*/
            openingSection=1;
  
            OrderSuccess *success=[self getSuccessView];
            success.orderStr = orderStr;
  
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate* now = [NSDate date];
            NSDate* expectedDate = [now dateByAddingTimeInterval:2*24*60*60];
            success.expectedDateStr = [DateFormatter stringFromDate:expectedDate];
            success.pickUpStr=[NSString stringWithFormat:@"%@ %@",[DateFormatter stringFromDate:now],textFieldPickupTime.text] ;
            success.totalItemStr=[NSString stringWithFormat:@"%lu",(unsigned long)[saveItemsIDArray count]];
            
            success.totalDueStr=estimatedDue.text;
            
            success.deliveryto=textFieldDeliveryTo.text;
            success.deliverytime=textFieldDeliveryTime.text;
            success.Pickfrom=textFieldPickupFrom.text;
            success.Picktime=textFieldPickupTime.text;;
            success.customerID=customerid;
            success.specialRequest=textFieldSpecialRequest.text;
            success.itemArray=saveItemsArray;
            success.itemIDArray=saveItemsIDArray;
            success.itemColourArray=saveItemsColoursArray;
            success.itemCountArray=showItemCountArray;
            success.itemDetailsArray=itemsArray;
            
            success.laundryAmountStr = self.laundryAmountStr;
            success.maleAmountStr = self.maleAmountStr;
            success.femaleAmountStr = self.femaleAmountStr;

            [self.navigationController pushViewController:success animated:YES];
 /*       }
       [indicator stopAnimating];
   }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning!!!" message:@"Some problem while proceeding.... Please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
         ;*/
    }

-(FirstViewController *)getViewController
{
    FirstViewController *viewController;
    viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    return viewController;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Ok"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"" forKey:@"customerid"];
        [defaults setObject:@"" forKey:@"firstname"];
        [defaults synchronize];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers;
        controllers = [NSArray arrayWithObject:[self getViewController]];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if ([title isEqualToString:@"Yes"])
    {
        NSError *error;
        WebService *webServ=[[WebService alloc]init];
        NSData *data = [webServ postDataToServer:ORDER_DELETE param:[NSString stringWithFormat:@"&CustomerID=%@&OrderID=%@&",customerid,orderNoStr]];
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *orderDeatils=[dataDict objectForKey:@"orderID"];
        NSDictionary *orderDeatilsDict=[orderDeatils objectAtIndex:0];
        if ( [[orderDeatilsDict objectForKey:@"result"]isEqualToString:@"true"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Deleted Order Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            OrderStatus *order;
            order = [[OrderStatus alloc] initWithNibName:@"OrderStatus" bundle:nil];
            NSArray *controllers= [NSArray arrayWithObject:order];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            [indicator stopAnimating];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Couldn't delete order" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }

}
-(Boolean)validateFields
{
    if ([textFieldDeliveryTo.text isEqualToString:@""]||[textFieldDeliveryTime.text isEqualToString:@""],[textFieldPickupFrom.text isEqualToString:@""],[textFieldPickupTime.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning!!!" message:@"Please select delivery details" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return FALSE;
    }
    else if ([saveItemsArray count]==0||[saveItemsIDArray count]==0||[saveItemsColoursArray count]==0)
              {
                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning!!!" message:@"Please select the items" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                  [alert show];
                  return FALSE;
              }
              return TRUE;
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
-(OrderSuccess*)getSuccessView
{
    OrderSuccess *success;
    success= [[OrderSuccess alloc] initWithNibName:@"OrderSuccess_6" bundle:nil];
    return success;
}
- (IBAction)maeClicked:(id)sender {
    filterBtn = 1;
    [itemTableView reloadData];
}
- (IBAction)femaleClicked:(id)sender
{
    filterBtn = 2;
    [itemTableView reloadData];
}
- (IBAction)laundryClicked:(id)sender {
    filterBtn = 3;
    [itemTableView reloadData];
}
- (IBAction)othersClicked:(id)sender {
    filterBtn = 4;
    [itemTableView reloadData];
}

@end
