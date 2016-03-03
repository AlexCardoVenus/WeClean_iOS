//
//  NSDictionary+Internet.m
//  WeClean New
//
//  Created by Jamhub-Mac on 7/14/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "NSDictionary+Internet.h"

@implementation NSDictionary (Internet)
-(instancetype)setUrl:(NSString*)aUrl
{
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:aUrl]];
    
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if(connectionError==nil && data!=nil)
             self.di=[NSData dataWithData:data];
            }];
    
    
    return self;
}

@end
