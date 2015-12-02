//
//  main.m
//  CrashLogger
//
//  Created by Intern on 12/1/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        // Catch NSExceptions
        @catch (NSException* exception) {
            // Converting array of call-stack lines into string (using Fast Enumeration and integer is faster than traditional objectAtIndex)
            NSMutableString * strCallStackSymbols =[[NSMutableString alloc] init];
            for (NSString* callStackSymbol in exception.callStackSymbols)
            {
                [strCallStackSymbols appendFormat:@"%@\n", callStackSymbol];
            }
            
            // Converting array of call-stack return addresses into string
            NSMutableString * strCallStack =[[NSMutableString alloc] init];
            NSUInteger callStackIndex=0;
            for (NSNumber* callStackReturnAddress in exception.callStackReturnAddresses)
            {
                [strCallStack appendFormat:@"%lu\t%@\n",callStackIndex,callStackReturnAddress];
                callStackIndex++;
            }
            
            // Constructing full exception string info
            NSMutableString* exceptionString=[[NSMutableString alloc] init];
            [exceptionString appendFormat:
             @"Name: %@\n"
             "Reason: %@\n"
             "User info: %@\n"
             "Throwed exception type: %@\n"
             "Functions stack:\n%@\n"
             "Functions' return addresses:\n%@\n",
             exception.name, exception.reason, exception.userInfo, [exception class], strCallStackSymbols, strCallStack];
            
            NSLog(@"Exception:\n%@", exceptionString);
        }
        // Catch other exception types which are id-type (such as NSString, NSObject). Logging their classes
        @catch (id exception){
            NSLog(@"Unhandled exception of type %@", [exception class]);
        }
        // Catch other thrown exception types. This one should not ever happen. If it happens, care carefully
        @catch (...){
            NSLog(@"Unhandled exception of unknown type");
        }
        @finally {
            NSLog(@"Finally block here [optional]");
        }
    }
}
