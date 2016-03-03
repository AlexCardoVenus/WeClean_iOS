//
//  ShopDetails.h
//  WeClean New
//
//  Created by Admin on 3/27/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetails : UIViewController
{
    IBOutlet UITextField *shopName;
    IBOutlet UITextField *phoneNo;
    IBOutlet UITextField *address;
    NSMutableArray *priceDetails;
    IBOutlet UITableView *storelist_tableView;
}

@property(nonatomic,retain) NSString *shopIDStr;
@end
