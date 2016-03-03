//
//  SqliteDataBase.h
//  NalaasRestaurant
//
//  Created by Jamhub-Mac on 5/27/15.
//  Copyright (c) 2015 Jamhub-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SqliteDataBase : NSObject{
    NSString * databasePath;
    
}
@property(nonatomic  ,retain)  NSDictionary *address_Dict;
@property(nonatomic  ,retain)  NSString *language;

+(SqliteDataBase*)getSharedInstance;
@end
