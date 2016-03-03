//
//  HowItWorks.m
//  WeClean New
//
//  Created by Admin on 3/27/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "HowItWorks.h"
#import "Constants.h"
#import "MFSideMenuContainerViewController.h"
@interface HowItWorks ()

@end

@implementation HowItWorks
UIActivityIndicatorView *indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Navigation bar appearance (background )
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.62 blue:0.56 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    myTableView.layer.borderColor = [UIColor grayColor].CGColor;
    myTableView.layer.borderWidth = 1.0f;
    [self setupMenuBarButtonItems];
    
}
//menu bar buttons
- (void)setupMenuBarButtonItems {
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    }
    [self rightBarButtonItem];
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
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"Do you want to Sign out?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Ok", nil];
        [alert show];
}

-(void)viewDidAppear:(BOOL)animated{
    [self getFaqs];
    
}
- (UIBarButtonItem *)backBarButtonItem {
    UIImage *backImage = [UIImage imageNamed:@"backarow.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 10, 30, 30);
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 7, 100, 30)];
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor whiteColor];
    //label.text=@"WeClean";
    [self.navigationController.navigationBar addSubview:label];
    
    
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

- (void)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getFaqs
{
    [self showprogressbar];
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:FAQS]];
    NSError *error;
    if (data!=nil)
    {
        NSDictionary *dataDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        faqArray=[dataDict objectForKey:@"faq"];
        [myTableView reloadData];
        [indicator stopAnimating];
    }
}
//tableview
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImage *myImage = [UIImage imageNamed:@"faq_image.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage] ;
    imageView.frame = CGRectMake(10,10,73,25);
    
    return imageView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [faqArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines=10;
    NSDictionary *dict=[faqArray objectAtIndex:indexPath.row];
    NSString *faqStr=[NSString stringWithFormat:@"Que-%@\n\nAns-%@",[dict objectForKey:@"question"],[dict objectForKey:@"answer"]];
    cell.textLabel.text=faqStr;
   
    return cell;
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
