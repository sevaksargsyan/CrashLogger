//
//  ServerLogger.m
//  CrashLogger
//
//  Created by SS on 12/4/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import "ServerLogger.h"
#import "CrashLoggerUtilities.h"

@implementation ServerLogger

- (BOOL) handle:(NSString *)log withLevel:(CRLLogLevel)level withKey:(NSString *)key {
    // Here we receive all the log (like in XCode's Output window)
    
    // ... TODO: Send log to server ...
    // Note: Use another thread with dispatch_async and use serial queues.
    // Wait for timeout after sending, and if timeout ends, notify CrashLogger about it (like "Couldn't send log to the server")
    
    // PROTOTYPE: sends request synchronously to server
    NSURL* url=[NSURL URLWithString: [NSString stringWithFormat:@"http://www.example.com/log.asp?level=%lu&key=%@&log=%@", (unsigned long)level, key, log]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    NSData *response=nil;
    response=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if (response==nil || requestError!=nil) {
        NSLog(@"ERROR: Data was not sent to server.");
        NSLog(@"%@", requestError);
    } else {
        NSLog(@"SUCCESS: Data was successfully sent to server.");
    }
    
    return true;
}

- (BOOL) handleObject:(id)object withLevel:(CRLLogLevel)level withKey:(NSString *)key {
    // Try to convert object (NSException, etc) to string
    NSString* str=nil;
    str=[CrashLoggerUtilities ConvertToString:object];
    
    // If conversion failed, then it's unknown object type, log object's class
    if (str==nil){
        str=[NSString stringWithFormat:@"Unknown exception/object of type: %@", NSStringFromClass([object class])];
    }
    
    return [self handle:str withLevel:level withKey:key];
}

@end
