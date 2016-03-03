//
//  SqliteDataBase.m
//  NalaasRestaurant
//
//  Created by Jamhub-Mac on 5/27/15.
//  Copyright (c) 2015 Jamhub-Mac. All rights reserved.
//

#import "SqliteDataBase.h"
static SqliteDataBase *sharedInstance = nil;

@implementation SqliteDataBase
//
+(SqliteDataBase*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        //[sharedInstance createDB];
    }
    return sharedInstance;
}

@end
