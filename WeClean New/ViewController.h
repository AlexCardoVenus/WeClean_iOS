//
//  ViewController.h
//  WeClean New
//
//  Created by Admin on 3/15/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UITextField *userid;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *forgotpassword;

- (IBAction)forgotPassword:(id)sender;


@end

