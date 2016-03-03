//
//  SideMenuViewController.m
//  BlueFish
//
//  Created by Ketan Reef on 7/14/14.
//  Copyright (c) 2014 Reefcube Ltd. All rights reserved.
//

#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "WebService.h"
#import "ViewController.h"
#import "PlaceOrder.h"
#import "OrderStatus.h"
#import "SignupUserViewController.h"
#import "SqliteDataBase.h"
#import "ShopDetails.h"
#import "HelpViewController.h"
#import "PromotionsController.h"
#import "FirstViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.parentViewController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
 
    [super viewDidLoad];
    adWebView.scalesPageToFit=YES;
    if([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]){
        sideMenuTitles=[[NSArray alloc]initWithObjects:@"Home",@"History",@"Promotions",@"Setting", @"Help", @"About", nil];

    }else{
        sideMenuTitles=[[NSArray alloc]initWithObjects:@"家",@"下單",@"訂單列表",@"賬戶設定", nil];
    }
        menuIconsArray=[[NSArray alloc]initWithObjects:@"Sidebar_Home.png",@"Sidebar_Order.png",@"Sidebar_Orderlist.png", @"Sidebar_Account.png", @"", @"", nil];
    WebService *webServ=[[WebService alloc]init];
    if ([webServ checkInternetConnection]==TRUE) {
    }
   
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
        cell.textLabel.text=[sideMenuTitles objectAtIndex:indexPath.row];
//        cell.imageView.image=[UIImage imageNamed:[menuIconsArray objectAtIndex:indexPath.row] ] ;
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers;
    
    if (indexPath.row==0) {
        PlaceOrder *order;
        if ([[UIScreen mainScreen]bounds].size.height == 568||[[UIScreen mainScreen]bounds].size.height == 480)
        {
            order = [[PlaceOrder alloc] initWithNibName:@"PlaceOrder" bundle:nil];
        }
        else
        {
            order = [[PlaceOrder alloc] initWithNibName:@"PlaceOrder_6" bundle:nil];
        }
        controllers = [NSArray arrayWithObject:order];
    }
    else if (indexPath.row==1)
    {
        controllers = [NSArray arrayWithObject:[self getOrderStatus]];
    }
    //Promotions
    else if (indexPath.row==2) {
        PromotionsController* promotionView = [[PromotionsController alloc] init];
        controllers = [NSArray arrayWithObject:promotionView];
    }
    else if (indexPath.row==3) {
        SignupUserViewController *signUp = [[SignupUserViewController alloc] init];
        signUp.modifyOption=TRUE;
        controllers = [NSArray arrayWithObject:signUp];
    }
    else if (indexPath.row == 4)
    {
        HelpViewController* helpView = [[HelpViewController alloc] init];
        controllers = [NSArray arrayWithObject:helpView];
    }
//  About
    else
    {
        ShopDetails* detail = [[ShopDetails alloc] init];
        controllers = [NSArray arrayWithObject:detail];
    }
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

-(OrderStatus *)getOrderStatus
{
    OrderStatus *order;
    order = [[OrderStatus alloc] initWithNibName:@"OrderStatus" bundle:nil];
    return order;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
