//
//  HelpViewController.m
//  WeClean New
//
//  Created by Never.SMile on 12/30/15.
//  Copyright © 2015 com.Jamhub. All rights reserved.
//

#import "HelpViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "FirstViewController.h"
#import "SqliteDataBase.h"

@interface HelpViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuBarButtonItems];
    _scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    _scrollView.layer.borderWidth = 2;
    _scrollView.layer.cornerRadius = 5;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width - 100, 540);
    self.navigationItem.title = @"Help";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.62 blue:0.56 alpha:1];
    // Do any additional setup after loading the view from its nib.
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
{  /*yjy11516@gmail.com moranbong  google drive*/
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
