//
//  OrderStatusTable.m
//  weclean
//
//  Created by Arun Rajkumar on 22/01/15.
//  Copyright (c) 2015 Jamhub. All rights reserved.
//

#import "OrderStatusTable.h"

@implementation OrderStatusTable
@synthesize OrdernoLabel = _OrdernoLabel;
@synthesize orderdateLabel = _orderdateLabel;
@synthesize OrderStatus = _OrderStatus;
@synthesize OrderPaymentStatus = _OrderPaymentStatus;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
