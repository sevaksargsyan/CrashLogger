//
//  ServerLogger.m
//  CrashLogger
//
//  Created by Intern on 12/4/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import "ServerLogger.h"
#import "CrashLoggerUtilities.h"

@implementation ServerLogger

- (BOOL) handle: (NSString*) log{
    // Here we receive all the log (like in XCode's Output window)
    
    // ... TODO: Send log to server ...
    // Note: Use another thread with dispatch_async and use serial queues.
    // Wait for timeout after sending, and if timeout ends, notify CrashLogger about it (like "Couldn't send log to the server")
    
    // PROTOTYPE: sends request synchronously to server
    NSURL* url= [NSURL URLWithString: [NSString stringWithFormat:@"http://www.example.com/log.asp?log=%@", log]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    NSData *response=nil;
    response=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if (response==nil || requestError!=nil) return false;
    NSLog(@"SUCCESS: Data was successfully sent to server.");
    
    return true;
}

- (BOOL) handleObject:(id)object {
    // If it's NSException (or derived type), then convert it to string and log as string
    if ([object isKindOfClass:[NSException class]]){
        return [self handle:[CrashLoggerUtilities NSExceptionToString:object]];
    }
    return false;
}
@end
