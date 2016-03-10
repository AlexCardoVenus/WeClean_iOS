//
//  OrderStatus.m
//  weclean
//
//  Created by Arun Rajkumar on 04/01/15.
//  Copyright (c) 2015 Jamhub. All rights reserved.
//

#import "OrderStatus.h"
#import "OrderStatusTable.h"
#import "Constants.h"
#import "PlaceOrder.h"
#import "MFSideMenuContainerViewController.h"
#import "WebService.h"
#import "PlaceOrder.h"
#import "FirstViewController.h"
#import "SqliteDataBase.h"
#import "KLCPopup.h"

typedef NS_ENUM(NSInteger, FieldTag) {
    FieldTagHorizontalLayout = 1001,
    FieldTagVerticalLayout,
    FieldTagMaskType,
    FieldTagShowType,
    FieldTagDismissType,
    FieldTagBackgroundDismiss,
    FieldTagContentDismiss,
    FieldTagTimedDismiss,
};


typedef NS_ENUM(NSInteger, CellType) {
    CellTypeNormal = 0,
    CellTypeSwitch,
};


@interface OrderStatus (){
    NSArray* _horizontalLayouts;
    NSArray* _verticalLayouts;
    NSArray* _maskTypes;
    NSArray* _showTypes;
    NSArray* _dismissTypes;
    NSMutableArray *tableData;
    NSMutableArray *OrderIdarray;
    NSMutableArray *OrderDatearray;
    NSMutableArray *OrderStatusarray;
    NSMutableArray *OrderPaymentarray;
    UIActivityIndicatorView *indicator;
    NSInteger _selectedRowInHorizontalField;
    NSInteger _selectedRowInVerticalField;
    NSInteger _selectedRowInMaskField;
    NSInteger _selectedRowInShowField;
    NSInteger _selectedRowInDismissField;
    BOOL _shouldDismissOnBackgroundTouch;
    BOOL _shouldDismissOnContentTouch;
    BOOL _shouldDismissAfterDelay;
    KLCPopup* popup;
}

- (void)dismissButtonPressed:(id)sender;

@end

@implementation UIColor (KLCPopupExample)

+ (UIColor*)klcLightGreenColor {
    return [UIColor colorWithRed:(184.0/255.0) green:(233.0/255.0) blue:(122.0/255.0) alpha:1.0];
}

+ (UIColor*)klcGreenColor {
    return [UIColor colorWithRed:(0.0/255.0) green:(204.0/255.0) blue:(134.0/255.0) alpha:1.0];
}

@end

@implementation OrderStatus

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    
    // Minimum code required to use the segmented control with the default styling.
    
    tableData=[[NSMutableArray alloc]init];
    OrderIdarray=[[NSMutableArray alloc]init];
    
    OrderDatearray=[[NSMutableArray alloc]init];
    
    OrderStatusarray=[[NSMutableArray alloc]init];
    
    OrderPaymentarray=[[NSMutableArray alloc]init];
    
    //  self.navigationController.navigationBarHidden = YES;
    
    [self setupMenuBarButtonItems];
    [scrollView setContentSize:CGSizeMake(320,500)];
    btnSubmit.hidden=TRUE;
    backgrndView.layer.borderColor = [UIColor grayColor].CGColor;
    backgrndView.layer.borderWidth = 1.0f;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    customerid = [defaults objectForKey:@"customerid"];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.62 blue:0.56 alpha:1];
    
    if ([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]) {
        self.navigationItem.title = @"Order Status";
    }
    else{
        self.navigationItem.title = @"訂單狀態";
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    //Add border to textview
    self.feedback_tv.layer.borderWidth = 1.0f;
    self.feedback_tv.layer.borderColor = [[UIColor grayColor] CGColor];
    self.feedback_tv.layer.cornerRadius = 3.0f;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self setupMenuBarButtonItems];
}
-(void)viewDidAppear:(BOOL)animated{
    [self showprogressbar];
    NSString *postparm = [NSString stringWithFormat:@"%@%@", @"CustomerID=", customerid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ORDER_STATUS_URL]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:postparm] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data!=nil){
            NSString *htmlSTR = [[NSString alloc] initWithData:data
                                                      encoding:NSUTF8StringEncoding];
            
            NSData *data = [htmlSTR dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            tableData = [json valueForKeyPath:@"history.OrderID"];
            OrderDatearray = [json valueForKeyPath:@"history.Time1"];
            OrderStatusarray = [json valueForKeyPath:@"history.Status"];
            OrderPaymentarray = [json valueForKeyPath:@"history.paymentStatus"];
            [indicator stopAnimating];
            //tableData = OrderIdarray;
            if(![tableData isEqual: [NSNull null]])
                [orderTableView reloadData];
        }
        else{
            
            
        }
    }];
    
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

//menu bar buttons
- (void)setupMenuBarButtonItems {
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    
    return tableData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"OrderStatusTable";
    
    OrderStatusTable *cell = (OrderStatusTable *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderStatusTable" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.tag=indexPath.row;
    cell.OrdernoLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.orderdateLabel.text = [OrderDatearray objectAtIndex:indexPath.row];
    cell.OrderStatus.text = [OrderStatusarray objectAtIndex:indexPath.row];
    cell.OrderPaymentStatus.text = [OrderPaymentarray objectAtIndex:indexPath.row];
    
    if ([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]) {
        
    }
    else{
        if([cell.OrderPaymentStatus.text isEqualToString:@"not paid"]){
            cell.OrderPaymentStatus.text=@"未付";
        }
        if([cell.OrderStatus.text isEqualToString:@"waiting"]){
            cell.OrderStatus.text = @"等待";
        }
        
    }
    
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(void)showPopup
{
    UIView* contentView = [[UIView alloc] init];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0, 0, viewWidth - 20, 200);
    
    UIImageView* comingImage = [[UIImageView alloc] init];
    [comingImage setImage:[UIImage imageNamed:@"checking.png"]];
    comingImage.frame= CGRectMake(20 , 40, 23, 23);
    UILabel* comingLabel = [[UILabel alloc] init];
    comingLabel.backgroundColor = [UIColor clearColor];
    comingLabel.textColor = [UIColor blackColor];
    comingLabel.font = [UIFont boldSystemFontOfSize:10];
    comingLabel.frame = CGRectMake(10, 65, viewWidth / 2 - 10, 20);
    comingLabel.text = @"Coming";
    
    UIImageView* pickedImage = [[UIImageView alloc] init];
    [pickedImage setImage:[UIImage imageNamed:@"end.png"]];
    pickedImage.frame= CGRectMake(80 , 40, 23, 23);
    UILabel* pickedLabel = [[UILabel alloc] init];
    pickedLabel.backgroundColor = [UIColor clearColor];
    pickedLabel.textColor = [UIColor blackColor];
    pickedLabel.font = [UIFont boldSystemFontOfSize:10];
    pickedLabel.frame = CGRectMake(70, 65, viewWidth / 2 - 10, 20);
    pickedLabel.text = @"PickedUp";
    
    UIImageView* workingImage = [[UIImageView alloc] init];
    [workingImage setImage:[UIImage imageNamed:@"end.png"]];
    workingImage.frame= CGRectMake(140 , 40, 23, 23);
    UILabel* workingLabel = [[UILabel alloc] init];
    workingLabel.backgroundColor = [UIColor clearColor];
    workingLabel.textColor = [UIColor blackColor];
    workingLabel.font = [UIFont boldSystemFontOfSize:10];
    workingLabel.frame = CGRectMake(130, 65, viewWidth / 2 - 10, 20);
    workingLabel.text = @"Working";
    
    UIImageView* cleanedImage = [[UIImageView alloc] init];
    [cleanedImage setImage:[UIImage imageNamed:@"end.png"]];
    cleanedImage.frame= CGRectMake(200 , 40, 23, 23);
    UILabel* cleanedLabel = [[UILabel alloc] init];
    cleanedLabel.backgroundColor = [UIColor clearColor];
    cleanedLabel.textColor = [UIColor blackColor];
    cleanedLabel.font = [UIFont boldSystemFontOfSize:10];
    cleanedLabel.frame = CGRectMake(190, 65, viewWidth / 2 - 10, 20);
    cleanedLabel.text = @"Cleaned";
    
    UIImageView* deliveringImage = [[UIImageView alloc] init];
    [deliveringImage setImage:[UIImage imageNamed:@"end.png"]];
    deliveringImage.frame= CGRectMake(260 , 40, 23, 23);
    UILabel* deliveringLabel = [[UILabel alloc] init];
    deliveringLabel.backgroundColor = [UIColor clearColor];
    deliveringLabel.textColor = [UIColor blackColor];
    deliveringLabel.font = [UIFont boldSystemFontOfSize:10];
    deliveringLabel.frame = CGRectMake(245, 65, viewWidth / 2 - 10, 20);
    deliveringLabel.text = @"Delivering";
    
    UIImageView* deliveredImage = [[UIImageView alloc] init];
    [deliveredImage setImage:[UIImage imageNamed:@"end.png"]];
    deliveredImage.frame= CGRectMake(315 , 40, 23, 23);
    UILabel* deliveredLabel = [[UILabel alloc] init];
    deliveredLabel.backgroundColor = [UIColor clearColor];
    deliveredLabel.textColor = [UIColor blackColor];
    deliveredLabel.font = [UIFont boldSystemFontOfSize:10];
    deliveredLabel.frame = CGRectMake(305, 65, viewWidth / 2 - 10, 20);
    deliveredLabel.text = @"Delivered";
    
    UIButton* modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    modifyButton.backgroundColor = [UIColor klcGreenColor];
    modifyButton.frame = CGRectMake(120, 110, 140, 30);
    [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [modifyButton setTitleColor:[[modifyButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    modifyButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [modifyButton setTitle:@"Modify Order" forState:UIControlStateNormal];
    modifyButton.layer.cornerRadius = 6.0;
    [modifyButton addTarget:self action:@selector(modifyClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:modifyButton];

    UIButton* viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    viewButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    viewButton.backgroundColor = [UIColor klcGreenColor];
    viewButton.frame = CGRectMake(120, 152, 140, 30);
    [viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [viewButton setTitleColor:[[viewButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    viewButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [viewButton setTitle:@"Order Status" forState:UIControlStateNormal];
    viewButton.layer.cornerRadius = 6.0;
    [viewButton addTarget:self action:@selector(viewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:viewButton];
    
    [contentView addSubview:comingImage];
    [contentView addSubview:comingLabel];
    [contentView addSubview:pickedImage];
    [contentView addSubview:pickedLabel];
    [contentView addSubview:workingImage];
    [contentView addSubview:workingLabel];
    [contentView addSubview:cleanedImage];
    [contentView addSubview:cleanedLabel];
    [contentView addSubview:deliveringImage];
    [contentView addSubview:deliveringLabel];
    [contentView addSubview:deliveredImage];
    [contentView addSubview:deliveredLabel];
    
    popup = [KLCPopup popupWithContentView:contentView];
    [popup show];
}


- (NSInteger)valueForRow:(NSInteger)row inFieldWithTag:(NSInteger)tag {
    
    NSArray* listForField = nil;
    if (tag == FieldTagHorizontalLayout) {
        listForField = _horizontalLayouts;
        
    } else if (tag == FieldTagVerticalLayout) {
        listForField = _verticalLayouts;
        
    } else if (tag == FieldTagMaskType) {
        listForField = _maskTypes;
        
    } else if (tag == FieldTagShowType) {
        listForField = _showTypes;
        
    } else if (tag == FieldTagDismissType) {
        listForField = _dismissTypes;
    }
    
    // If row is out of bounds, try using first row.
    if (row >= listForField.count) {
        row = 0;
    }
    
    if (row < listForField.count) {
        id obj = [listForField objectAtIndex:row];
        if ([obj isKindOfClass:[NSNumber class]]) {
            return [(NSNumber*)obj integerValue];
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showprogressbar];
    NSIndexPath *myIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    OrderStatusTable *cell = (OrderStatusTable*)[orderTableView cellForRowAtIndexPath:myIndex];
    selectedOrderID=cell.OrdernoLabel.text;
 
    [self showPopup];
/*    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Select", @"")  message:@"Status: Waiting" delegate:self cancelButtonTitle:NSLocalizedString(@"Modify Order" , @"Modify Order" ) otherButtonTitles:NSLocalizedString(@"View Order status", @"View Order status") ,nil];
        
        [alert show];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Select", @"")  message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"變更 訂購" , @"變更 訂購" ) otherButtonTitles:NSLocalizedString(@"查看 訂購 狀態", @"查看 訂購 狀態") ,nil];
        [alert show];
 
    }*/
    [indicator stopAnimating];
    
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
        NSArray *controllers = [NSArray arrayWithObject:[self getViewController]];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }

}

-(NSString*)getDiscoutForOrder
{
    NSError *error;
    NSString *postparm= [NSString stringWithFormat:@"&orderid=%@",selectedOrderID];
    WebService *webServ=[[WebService alloc]init];
    NSData *data = [webServ postDataToServer:DISCOUNT_OFORDER param:postparm];
    if (data!=nil) {
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *orderDeatils=[dataDict objectForKey:@"disc"];
        NSDictionary *aDict=[orderDeatils objectAtIndex:0];
        return [aDict objectForKey:@"Discount"];
    }
    return nil;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *textStr= [text stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
    //btnSubmit.hidden=FALSE;
    if ([textView.text length]!=0|| [textStr length]!=0) {
        btnSubmit.hidden=FALSE;
        
    }
    
    
    else
    {
        [textView resignFirstResponder];
        btnSubmit.hidden=TRUE;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextField *)textView;

{
    //    [scrollView setContentOffset:CGPointMake(0,textView.frame.origin.y-1.38f*textView.frame.size.height) animated:YES];
}
-(void)textViewDidEndEditing:(UITextField *)textView;
{
    [textView resignFirstResponder];
    //  [scrollView setContentOffset:CGPointMake(0,-60) animated:YES];
    
}
-(IBAction)clickedBtnSubmit:(id)sender
{
    
    if ([_feedback_tv.text length]!=0) {
        [self showprogressbar];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:INSERT_COMMENT]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[[NSString stringWithFormat:@"comment=%@",_feedback_tv.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data!=nil){
                _feedback_tv.text=@"";
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Inserted comment Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
//                [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
            }
            else{
                
            }
        }];
        [indicator stopAnimating];
    }
    else
    {
        btnSubmit.hidden=TRUE;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please insert comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
    
}
-(IBAction)clickedBtnPlaceOrder:(id)sender
{
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    PlaceOrder *order;
    order = [[PlaceOrder alloc] initWithNibName:@"PlaceOrder_6" bundle:nil];
    NSArray *controllers= [NSArray arrayWithObject:order];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
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


-(void)modifyClicked:(UIButton*)sender
{
    [popup dismiss:YES];
    [self showStatus:0];
}

-(void)viewClicked:(UIButton*)sender
{
    [popup dismiss:YES];
    [self showStatus:1];
}

-(void)showStatus:(NSInteger)buttonIndex
{
    [self showprogressbar];
    NSString *postparm = [NSString stringWithFormat:@"%@%@", @"CustomerID=", customerid];
    WebService *webServ=[[WebService alloc]init];
    NSData *data = [webServ postDataToServer:ITEM_COST_URL param:postparm];
    NSError *error;
    if (data!=nil){
        //success
        NSArray* itemsArrayDetails;
        NSDictionary *dataDictNew=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
       if(![dataDictNew isEqual: [NSNull null]])
       {
           itemsArrayDetails=[dataDictNew objectForKey:@"Itemcost"];
       }
        //HTTPPOST login
        NSError *error;
        NSString *postparm= [NSString stringWithFormat:@"&orderid=%@",selectedOrderID];
        NSData *data = [webServ postDataToServer:RETRIEVE_ORDER param:postparm];
        
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        
        if ([dataDict isKindOfClass:[NSNull class ]]) {
            NSString *message = @"This Order is Closed";
            
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];
            
            int duration = 1; // duration in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });
            [indicator stopAnimating];
            
        }
        else{
            NSArray *orderDeatils=[dataDict objectForKey:@"orderdetails"];
            NSDictionary *orderDeatilsDict=[orderDeatils objectAtIndex:0];
            PlaceOrder *order;
            order = [[PlaceOrder alloc] initWithNibName:@"PlaceOrder_6" bundle:nil];
             
            order.orderNoStr=selectedOrderID;
            order.pickUpStr=[orderDeatilsDict objectForKey:@"Time1"];
            order.totalDueStr=[orderDeatilsDict objectForKey:@"TotalDue"];
            
            order.deliveryto=[orderDeatilsDict objectForKey:@"DeliveryOption"];
            order.deliverytime=[orderDeatilsDict objectForKey:@"DeliveryTimePreference"];
            order.Pickfrom=[orderDeatilsDict objectForKey:@"PickUpOption"];
            order.Picktime=[orderDeatilsDict objectForKey:@"PickUpTimepreference"];
            order.customerID=[orderDeatilsDict objectForKey:@"CustomerID"];
            order.specialRequest=[orderDeatilsDict objectForKey:@"OtherDetails"];
            order.itemArray=[[NSMutableArray alloc]init];
            order.itemIDArray=[[NSMutableArray alloc]init];
            order.itemColourArray=[[NSMutableArray alloc]init];
            order.itemsCountArray=[[NSMutableArray alloc]init];
            for (int i=0; i<[orderDeatils count]; i++) {
                NSDictionary *dict=[orderDeatils objectAtIndex:i];
                NSString *itemName;
                for (int k=0; k<[itemsArrayDetails count]; k++) {
                    NSDictionary *dict1=[itemsArrayDetails objectAtIndex:k];
                    if ([[dict objectForKey:@"itemid"] intValue]==[[dict1 objectForKey:@"ItemID"] intValue]) {
                        itemName=[dict1 objectForKey:@"ItemName"];
                        break;
                    }
                }
                
                for (int j=0; j<[[dict objectForKey:@"itemnos"]intValue]; j++) {
                    if(itemName != nil)
                        [order.itemArray addObject:itemName];
                    [order.itemsCountArray addObject:[dict objectForKey:@"itemnos"]];
                    [order.itemIDArray addObject:[dict objectForKey:@"itemid"]];
                    if ([[dict objectForKey:@"color"] length ]==0) {
                        [order.itemColourArray addObject:@"select color"];
                    }
                    else{
                        [order.itemColourArray addObject:[dict objectForKey:@"color"]];}
                }
            }
            
            
            if (buttonIndex==0) {
                order.openingSection=0;
            }
            else
            {
                order.openingSection=2;
            }
            [indicator stopAnimating];
            order.discountVal=[self getDiscoutForOrder];
            NSArray *controllers= [NSArray arrayWithObject:order];
            self.navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            
        }
    }
}

@end
