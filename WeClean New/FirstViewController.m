//
//  FirstViewController.m
//  WeClean New
//
//  Created by Yoshiro on 12/21/15.
//  Copyright © 2015 com.Jamhub. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"
#import "SignupUserViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signinClicked:(id)sender {
    ViewController* viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)registerClicked:(id)sender {
    self.navigationController.navigationBarHidden=NO;
    SignupUserViewController *signUp=[[SignupUserViewController alloc]init];
    signUp.modifyOption=FALSE;
    [self.navigationController pushViewController:signUp animated:YES];
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
