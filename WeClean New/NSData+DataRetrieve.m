//
//  NSData+DataRetrieve.m
//  WeClean New
//
//  Created by Jamhub-Mac on 7/14/15.
//  Copyright (c) 2015 com.Jamhub. All rights reserved.
//

#import "NSData+DataRetrieve.h"

@implementation NSData (DataRetrieve)
-(instancetype)setUrl:(NSString*)aUrl
{
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:aUrl]];
    
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if(connectionError==nil && data!=nil)
    
    }];
    
    
    return self;
}


@end


