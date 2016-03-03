//
//  AppDelegate.m
//  WeClean New
//
//  Created by Admin on 3/15/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "AppDelegate.h"
#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "FirstViewController.h"
#import "SqliteDataBase.h"
#import "HomeViewController.h"
#import "OrderStatus.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     [SqliteDataBase getSharedInstance].language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    SideMenuViewController *leftMenuViewController=[[SideMenuViewController alloc] init];
   
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationController]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];    [container setRightMenuWidth:320];
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];


    return YES;
}
- (UIViewController *)viewController {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *customerid = [defaults objectForKey:@"customerid"];
    NSString *firstname = [defaults objectForKey:@"firstname"];
    if([customerid length] != 0)
    {
        OrderStatus *viewController;
        viewController = [[OrderStatus alloc] initWithNibName:@"OrderStatus" bundle:nil];
     return viewController;
    }
    else
    {
    FirstViewController *viewController;
    viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];

    return viewController;
    }
  return nil;
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self viewController]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
