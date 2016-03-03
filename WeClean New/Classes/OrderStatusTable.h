//
//  OrderStatusTable.h
//  weclean
//
//  Created by Arun Rajkumar on 22/01/15.
//  Copyright (c) 2015 Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusTable : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *OrderPaymentStatus;
@property (weak, nonatomic) IBOutlet UILabel *OrderStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderdateLabel;

@property (weak, nonatomic) IBOutlet UILabel *OrdernoLabel;


@end
