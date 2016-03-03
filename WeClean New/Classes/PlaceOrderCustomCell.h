//
//  PlaceOrderCustomCell.h
//  WeClean New
//
//  Created by Admin on 3/18/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceOrderCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectColour;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectColour;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnDeduct;




@end
