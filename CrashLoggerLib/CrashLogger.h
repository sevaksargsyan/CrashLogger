//
//  CrashLogger.h
//  CrashLogger
//
//  Created by SS on 12/3/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogHandlingProtocol.h"

// Types of events // Not used/implemented yet
typedef NS_OPTIONS(NSUInteger, CRLEventLevel) {
    None        = 0,
    All         = NSUIntegerMax,
    
    Critical    = 1 << 0,   // Critical cases, such as system-level or low-level crashes, which can't be handled
    Error       = 1 << 1,   // Exceptions and errors
    Warning     = 1 << 2,   // Warnings, which can be handled or ignored if necessary
    Info        = 1 << 3,   // Information, which should be logged. Use CustomEvent when logging more specific info
    
    Debug       = 1 << 4,   // Debug info, for development purposes
    CustomEvent = 1 << 5    // Custom events, for logging specific events such as custom warning or stastics
};

@interface CrashLogger : NSObject

#pragma mark - Initialization and singleton

+ (instancetype) sharedInstance;                                            // Shared instance of singleton class
- (instancetype) init __attribute__((unavailable("use sharedInstance")));   // Init method call prevention - for preventing non-singleton instance creation

#pragma mark - Log handler registration

- (BOOL) registerLogHandler: (id <LogHandlingProtocol>) logHandler withID:(NSString*) handlerID;
//- (BOOL) registerLogHandler: (id <LogHandlingProtocol>) logHandler withID:(NSString*) handlerID forEventLevels:(CRLEventLevel) eventLevels;
- (BOOL) unregisterLogHandler: (NSString*) handlerID;

#pragma mark - Logging methods

- (void) log: (NSString*) format,...;
- (void) logObject: (id) object;
- (void) logNSString: (NSString*) info;

#pragma mark - Global uncaught exception Handler

// Returns pointer to CrashLogger's function which will handle global exceptions.
// Set it as global handler using NSSetUncaughtExceptionHandler([... uncaughtExceptionHandler]) from functions [application:didFinish] or from main (before "return")
- (NSUncaughtExceptionHandler*) uncaughtExceptionHandler;

#pragma mark - Safe blocks

// Safely executes the block and logs exceptions
+ (id)safeBlock:(id(^)(void))block;

@end
