//
//  WebService.m
//  BlueFish
//
//  Created by Admin on 8/11/14.
//  Copyright (c) 2014 Reefcube Ltd. All rights reserved.
//

#import "WebService.h"
#import "Reachability.h"

@implementation WebService{
 NSData *jsonSon;
}
//check whether internet connection is available or not
-(Boolean)checkInternetConnection
{
    Reachability *internetReachableFoo = [Reachability reachabilityWithHostname:@"www.apple.com"];
    NetworkStatus internetStatus = [internetReachableFoo currentReachabilityStatus];
    if (internetStatus == NotReachable)
    {
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BlueFish eMarketing" message:@"No internet connection" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
        [alert show];*/
        return FALSE;
    }
    return TRUE;
    
}

-(NSData *)postDataToServer:(NSString*)urlString param:(NSString*)param
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:param] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        return nil;
    }
    else{
        return data;
}
    return nil;
}
-(NSData*)postOrder:(NSString*)urlString param:(NSString*)param
{
    NSError *error = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error]];
    [request setHTTPMethod:@"POST"];
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        return nil;
    }
    else{
        return data;
    }
    return nil;
}
@end
