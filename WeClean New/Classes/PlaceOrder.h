//
//  PlaceOrder.h
//  weclean
//
//  Created by Arun Rajkumar on 22/01/15.
//  Copyright (c) 2015 Jamhub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceOrder : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
 IBOutlet UITableView *itemTableView;
 IBOutlet UIBarButtonItem *barButton;
 NSArray* itemsArray;
 NSInteger addedToCartArray[15];
    
 NSArray *coloursArray,*colourNameArray;
 NSMutableArray *saveItemsArray,*saveItemsIDArray,*saveItemsColoursArray;
    
    NSMutableArray *showItemCountArray,*showItemColourArray;
    
    UILabel *estimatedDue;
    IBOutlet UILabel *totalEstimate;
    UILabel *totalItems;
    
    UIView *colourView;
    int mainTagValCopy;
    
    IBOutlet UITextField *textFieldPickupFrom;
    IBOutlet UITextField *textFieldPickupTime;
    
    UITextField *selectedTextField;
    
    NSString *selectedText;
    
    IBOutlet UITextField *textFieldSpecialRequest;
    NSString *customerid;
    IBOutlet UIButton *btnPlaceOrder,*btnModifyOrder,*btnDeleteOrder;
    IBOutlet UIView *uitableViewBorder,*costViewBorder;
   
}
@property(assign)int openingSection;

@property(nonatomic,retain)NSString *laundryAmountStr;
@property(nonatomic,retain)NSString *maleAmountStr;
@property(nonatomic,retain)NSString *femaleAmountStr;

@property(nonatomic,retain)NSString *orderNoStr;
@property(nonatomic,retain)NSString *pickUpStr;
@property(nonatomic,retain)NSString *totalDueStr;
@property(nonatomic,retain)NSString *deliveryto;
@property(nonatomic,retain)NSString *deliverytime;
@property(nonatomic,retain)NSString *Pickfrom;
@property(nonatomic,retain)NSString *Picktime;
@property(nonatomic,retain)NSString *customerID;
@property(nonatomic,retain)NSString *specialRequest;
@property(nonatomic,retain)NSMutableArray *itemArray;
@property(nonatomic,retain)NSMutableArray *itemIDArray;
@property(nonatomic,retain)NSMutableArray *itemColourArray;
@property(nonatomic,retain)NSMutableArray *itemsCountArray;
@property(nonatomic,retain)NSString *discountVal;
@property(nonatomic,retain)NSString *promoCodeVal;

-(IBAction)dropDownClicked:(id)sender;

@end
