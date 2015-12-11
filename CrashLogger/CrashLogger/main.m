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
        
        // Note: This application tests CrashLogger's various exception/error catching and log handling mechanisms.
        // We will crash the application in different ways to test CrashLogger.
        
        // Registering log handlers. They will receive all logs and handle them.
        DebugLogger* debugLogger=[[DebugLogger alloc] init];
        [CRL registerLogHandler:debugLogger withName:@"NSLogger" forEventLevels:All forCustomKeys:nil];
        
        ServerLogger* serverLogger=[[ServerLogger alloc]init];
        //[CRL registerLogHandler:serverLogger withName:@"Server Logger"]; // Apple allows https connection to servers // Not tested because it requires server with SSL/https connection

        // Testing log handler. It will send this log to all log handlers.
        [CRL log:@"Log handler worked successfully!"];
        
        // Logging levels (Critical, Error, Warning, Info, Debug) make logs more readable and easy to filter
        [CRL logWithLevel:Warning format:@"This is a sample log with warning level"];
        
        // In addition to logging levels, CrashLogger allows usage of custom keys
        // Custom keys can be used for logging advanced info, such as statistics, events, etc. It allows convenient log filtering.
        // A log handler is allowed to subscribe to these keys and receive logs of these types.
        // (For example, a logger can be registered to receive only statistics or login info, and send them to server; or a log handler can listen to exceptions and warnings, and send them to server only)
        // Here is an example, where "LogIn" and "Statistics" are custom keys, and a log handler (customLogger) listens to these keys. This way it can filter logs and respond only to the selected keys:
        DebugLogger * customLogger=[[DebugLogger alloc] init];
        [CRL registerLogHandler:customLogger withName:@"CustomLogger" forEventLevels:None forCustomKeys:@[@"LogIn", @"Statistics"]];
        [CRL logWithKey:@"LogIn" format:@"User was logged in", @"asd"];
        [CRL logWithKey:@"Statistics" format:@"User has clicked button %@", @"MyButtonName"];

        // Testing CrashLogger's Safe Blocks
        [CrashLogger safeBlock:^{
            NSLog(@"\n\nChecking safe blocks - get over bounds of array, and it will catch exceptions and log them");
            NSArray* overflowedArray = [[NSArray alloc] init];
            [overflowedArray objectAtIndex:2];
        }];
        
        // TESTING: two ways of crash (exception) catching. Comment or uncomment this line to see 2 types of exception catching.
        // Note: We have set global uncaught exception handler in file AppDelegate.m, in method [application didFinish...];
        // We will crash application in AppDelegate.m's [splitViewController collapse...] method, and catch exceptions remotely using 1) exception-chain-up catching 2) global uncaught exception handler
        //#define Without_NSSetUncaughtExceptionHandler

        #ifdef Without_NSSetUncaughtExceptionHandler
                // Safe way. Note that we catch the global uncaught exception in safe way, also we retrieved ALL the available debug info.
                // So we can log it to file and send it to server; and we will see user's logs like we see when from our XCode.
                // Catching uncaught exceptions. Uncaught exceptions go up in exception handling chain, and if there's no exception handler, they reach main() function and get caught there.
                @try {
                    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
                }
                @catch (id exception) {
                    NSLog(@"\n Exception was caught. Logging it\n");
                    [CRL logObject:exception];
                }
                // Catch other exception types. This case should never happen as @throw only accepts object types. If it happens take care carefully
                @catch (...) {
                    NSLog(@"Unhandled exception of unknown type");
                }
        #else
                // Note: this one will catch exception using global uncaught exception handler, but program will crash in the end, because it receives SIGABRT (note: previous method didn't receive SIGABRT).
                // Note: scroll up the Output window, and notice that log repeats twice.
                // We could catch exception and fully retrieve ALL debug info and print it, it's the first part. We can log it to file and send to server.
                // The second part was printed by XCode as usual, because exception was thrown again.
                return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        #endif
        
    }
}
