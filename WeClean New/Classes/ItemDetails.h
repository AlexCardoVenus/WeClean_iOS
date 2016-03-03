//
//  ItemDetails.h
//  WeClean New
//
//  Created by Admin on 3/23/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemDetails : NSObject

@property(nonatomic,retain)NSString *itemID;
@property(nonatomic,retain)NSString *itemName;
@property(nonatomic,retain)NSString *itemNameChinese;
@property(nonatomic,retain)NSString *itemPrice;
@property(nonatomic,retain)NSString *shopID;
@property(nonatomic,retain)NSString *itemImgName;

-(ItemDetails *)setValues:(NSDictionary*)aDict;

@end
