//
//  NSData+DataConnection.m
//  WeClean New
//
//  Created by Jamhub-Mac on 7/14/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "NSData+DataConnection.h"

@implementation NSData (DataConnection)
-(NSData *)setUrl:(NSString*)aUrl param:(NSString *)param
{
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:aUrl]];
    
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
   
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if(connectionError==nil && data!=nil)
        data=[NSData dataWithData:data];
        
        
    }];
    
    
    return self;
}
@end
