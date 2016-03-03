//
//  OrderStatus.h
//  weclean
//
//  Created by Arun Rajkumar on 04/01/15.
//  Copyright (c) 2015 Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatus : UIViewController <UITableViewDelegate, UITableViewDataSource,UITextViewDelegate>
{
    IBOutlet UITableView *orderTableView;
    NSString *selectedOrderID;
    NSString *customerid;
    IBOutlet UIView *backgrndView;
    IBOutlet UIButton *btnSubmit;
    IBOutlet UIScrollView *scrollView;
}
@property (weak, nonatomic) IBOutlet UIButton *placeorderButton;
@property (weak, nonatomic) IBOutlet UITextView *feedback_tv;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

-(IBAction)clickedBtnSubmit:(id)sender;
//-(IBAction)clickedBtnPlaceOrder:(id)sender;
@end
