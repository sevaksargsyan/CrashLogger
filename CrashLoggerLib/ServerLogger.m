//
//  ServerLogger.m
//  CrashLogger
//
//  Created by Intern on 12/4/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import "ServerLogger.h"

@implementation ServerLogger

- (BOOL) handle: (NSString*) log{
    // Here we receive all log (like in XCode's Output window)
    
    // ... TODO: Send log to server ...
    // Note: Use another thread with dispatch_async and use serial queues.
    // Wait for timeout after sending, and if timeout ends, notify CrashLogger about it (like "Couldn't send log to the server")
    return true;
}

@end
