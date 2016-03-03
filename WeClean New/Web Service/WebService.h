//
//  WebService.h
//  BlueFish
//
//  Created by Admin on 8/11/14.
//  Copyright (c) 2014 Reefcube Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

-(Boolean)checkInternetConnection;
-(NSData *)postDataToServer:(NSString*)urlString param:(NSString*)param;
-(NSData*)postOrder:(NSString*)urlString param:(NSString*)param;

@end
