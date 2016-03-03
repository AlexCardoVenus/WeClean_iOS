//
//  ShopDetails.m
//  WeClean New
//
//  Created by Admin on 3/27/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "ShopDetails.h"
#import "Constants.h"
#import "WebService.h"
#import "MFSideMenuContainerViewController.h"
#import "SqliteDataBase.h"
#import "FirstViewController.h"

@interface ShopDetails ()

@end

@implementation ShopDetails
@synthesize shopIDStr;
UIActivityIndicatorView *indicator;

- (void)viewDidLoad {
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.shopIDStr = @"101";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.62 blue:0.56 alpha:1];
    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
          self.navigationItem.title =  @"Shop Details";
    }else{
          self.navigationItem.title =  @"店鋪詳細";
    }
  
  //  self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    [self setupMenuBarButtonItems];
    [super viewDidLoad];
    [self getShopDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)setupMenuBarButtonItems {
    if(self.menuContainerViewController.menuState != MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
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


- (IBAction)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
    }];
}

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [priceDetails count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text=[priceDetails objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)getShopDetails
{
    [self showprogressbar];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GET_SHOP_DETAILS]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"shopid=%@",self.shopIDStr] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
    if (data!=nil){
        //success
        priceDetails=[[NSMutableArray alloc]init];
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray*  itemsArray=[dataDict objectForKey:@"Shopdetails"];
        NSDictionary *dict=[itemsArray objectAtIndex:0];
        
        phoneNo.text=[dict objectForKey:@"phone"];
        if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            shopName.text=[dict objectForKey:@"shopname"];
            address.text=[dict objectForKey:@"address"];
        }else{
            shopName.text=[dict objectForKey:@"shopnameC"];
            address.text=[dict objectForKey:@"addressC"];
        }
       
        for (int i=0; i<[itemsArray count]; i++) {
            NSDictionary *dict=[itemsArray objectAtIndex:i];
            if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
            NSString *str=[NSString stringWithFormat:@"%@ - %@HK$",[dict objectForKey:@"ItemName"],[dict objectForKey:@"Price"]];
                [priceDetails addObject:str];
            }else
            {
                 NSString *str=[NSString stringWithFormat:@"%@ - %@HK$",[dict objectForKey:@"ItemNameChinese"],[dict objectForKey:@"Price"]];
                [priceDetails addObject:str];
            }
         
            
        }
        [storelist_tableView reloadData];
        [indicator stopAnimating];
    }
    else{
        
    }
    }];
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
