//
//  ItemDetails.m
//  WeClean New
//
//  Created by Admin on 3/23/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "ItemDetails.h"

@implementation ItemDetails
@synthesize itemID,itemImgName,itemName,itemNameChinese,itemPrice,shopID;

-(ItemDetails *)setValues:(NSDictionary*)aDict
{
   
    NSLog(@"%@",[aDict objectForKey:@"ItemName"]);
    self.itemID=[NSString stringWithFormat:@"%@",[aDict objectForKey:@"ItemID"]];
    self.itemName=[aDict objectForKey:@"ItemName"];
    self.itemNameChinese=[aDict objectForKey:@"ItemNameChinese"];
    self.itemPrice=[aDict objectForKey:@"Price"];
    self.shopID=[aDict objectForKey:@"ShopID"];
    self.itemImgName=[aDict objectForKey:@"itemImgName"];
    return self;
}

@end
