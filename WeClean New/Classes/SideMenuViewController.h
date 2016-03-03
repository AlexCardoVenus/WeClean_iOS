//
//  SideMenuViewController.h
//  BlueFish
//
//  Created by Ketan Reef on 7/14/14.
//  Copyright (c) 2014 Reefcube Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UIViewController
{
    NSArray *sideMenuTitles,*menuIconsArray;
    IBOutlet UITableView *sideMenuTableView;
    
    Boolean adButtonPressed;
    IBOutlet UIWebView *adWebView;
    IBOutlet UIImageView *adImageView;
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet UIButton *bottomBannerButton;
}

@end
