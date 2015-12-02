//
//  main.m
//  CrashLogger
//
//  Created by SS on 12/1/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CrashLoggerLib/CrashLoggerUtilities.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        // Catch NSExceptions
        @catch (NSException* exception) {
            NSString* exceptionString;
            exceptionString=[CrashLoggerUtilities NSExceptionToString:exception];
            
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
