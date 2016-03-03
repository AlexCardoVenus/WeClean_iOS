//
//  HomeViewController.m
//  WeClean New
//
//  Created by Never.SMile on 12/27/15.
//  Copyright © 2015 com.Jamhub. All rights reserved.
//

#import "HomeViewController.h"
#import "HMSegmentedControl.h"
#import "SqliteDataBase.h"
#import "MFSideMenuContainerViewController.h"
#import "ViewController.h"
#import "OrderStatus.h"
#import "PlaceOrder.h"
#import "FirstViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    [self setupMenuBarButtonItems];
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"History", @"Order"]];
    segmentedControl.frame = CGRectMake(0, 60, viewWidth, 40);
    segmentedControl.selectionIndicatorHeight = 4.0f;
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.62 blue:0.56 alpha:1];; /*#01a2d6*/
    
    if ([[SqliteDataBase getSharedInstance].language isEqualToString:@"en"]) {
        self.navigationItem.title = @"Home";
    }
    else{
        self.navigationItem.title = @"訂單狀態";
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
    //----Default
    [self showHistory_Order:0];

    // Do any additional setup after loading the view.
}

- (void)setupMenuBarButtonItems {
    if(self.menuContainerViewController.menuState != MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
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

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
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
        NSArray *controllers = [NSArray arrayWithObject:[self getFirstViewController]];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    
    else if([title isEqualToString:@"Cancel"]){
        
    }
}

-(FirstViewController* )getFirstViewController
{
    FirstViewController* viewController;
    viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    return viewController;
}

-(ViewController *)getViewController
{
    ViewController *viewController;
/*    if ([[UIScreen mainScreen]bounds].size.height == 568)
    {
        viewController = [[ViewController alloc] initWithNibName:@"ViewController_4inch" bundle:nil];
    }
    else  if ([[UIScreen mainScreen]bounds].size.height == 480)
    {
        viewController = [[ViewController alloc] initWithNibName:@"ViewController_3.5inch" bundle:nil];
    }
 */
    viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
 
    return viewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)showHistory_Order:(NSInteger)tabStyle
{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    if(tabStyle == 0)
    {
        if ([self.view viewWithTag:101] != nil)
            [[self.view viewWithTag:101] removeFromSuperview];
        OrderStatus *child = [[OrderStatus alloc] initWithNibName:@"OrderStatus" bundle:nil];
        [self addChildViewController:child];
        child.view.tag = 100;
        child.view.frame = CGRectMake(0, 100, viewWidth, 600);
        [self.view addSubview:child.view];
       [child didMoveToParentViewController:self];
        
    }
    else
    {
        if ([self.view viewWithTag:100] != nil)
            [[self.view viewWithTag:100] removeFromSuperview];
        PlaceOrder *child = [[PlaceOrder alloc] initWithNibName:@"PlaceOrder_6" bundle:nil];
        [self addChildViewController:child];
        child.view.tag = 101;
        child.view.frame = CGRectMake(10, 20, viewWidth, 700);
        [self.view addSubview:child.view];
        [child didMoveToParentViewController:self];
        [self.view sendSubviewToBack:child.view];
/*        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        PlaceOrder* placeController = [[PlaceOrder alloc] initWithNibName:@"PlaceOrder_6" bundle:nil];
        navigationController.viewControllers = [NSArray arrayWithObject:placeController];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];*/
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    [self showHistory_Order:segmentedControl.selectedSegmentIndex];
}


@end
