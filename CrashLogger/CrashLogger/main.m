//
//  main.m
//  CrashLogger
//
//  Created by SS on 12/1/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CrashLoggerLib.h"
#import "DebugLogger.h"
#import "ServerLogger.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        // TESTING: Log handlers
        // Registering log handlers. They will receive all logs and handle them.
        DebugLogger* debugLogger=[[DebugLogger alloc] init];
        [CRL registerLogHandler:debugLogger withID:@"NSLogger"];
        [CRL registerLogHandler:debugLogger withID:@"NSLogger2"];
        
        ServerLogger* serverLogger=[[ServerLogger alloc]init];
        [CRL registerLogHandler:serverLogger withID:@"Server Logger"];
        
        // Testing log handler. It will send this log to all log handlers.
        [CRL log:@"Log handler worked successfully"];
        
        
        // TESTING: two ways of crash catching. Comment or uncomment
        #define Without_NSSetUncaughtExceptionHandle
                
        #ifdef Without_NSSetUncaughtExceptionHandle
                // Safe way. Note that we catch the global uncaught exception in safe way, also we retrieved ALL the available debug info.
                // So we can log it to file and send it to server; and we will see user's logs like we see when from our XCode.
                // Catching uncaught exceptions. Uncaught exceptions go up in exception handling chain, and if there's no exception handler, they reach main() function and get caught there.
                @try {
                    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
                }
                @catch (id exception){
                    if ([exception class]==NSException.class){
                        // Then we caught NSException, converting it and logging
                        NSLog(@"\n Exception was caught\n%@\n",[CrashLoggerUtilities NSExceptionToString:exception]);
                        NSLog(@"This log can be sent to server or logged to file");
                    } else {
                        // Catch other exception types which are compatible with id type (such as NSString, NSObject). Logging their classes.
                        NSLog(@"\nUnhandled exception of type %@", [exception class]);
                    }
                }
                // Catch other exception types. This case should never happen as @throw only accepts object types. If it happens take care carefully
                @catch (...){
                    NSLog(@"Unhandled exception of unknown type");
                }
        #else
                // Note: this one will catch exception but will crash the program at the end.
                // Note: scroll up the Output window, and notice that log repeats twice.
                // We could catch exception and fully retrieve ALL debug info and print it, it's the first part. We can log it to file and send to server.
                // The second part was printed by XCode as usual, because exception was thrown again.
                return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        #endif
        
    }
}
