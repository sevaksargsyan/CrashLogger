//
//  CrashLogger
//  -----------
//
//      CrashLogger - crash logging, handling and reporting library.
//      Created by SSargsyan. Copyright © Macadamian, 2015.
//
//  General notes:
//  --------------
//      o To create custom log handlers (e.g for sending to server asynchronously), create a class and conform <LogHandlingProtocol>
//      o Use safe CrashLogger blocks to catch exceptions in place
//      o When catching exceptions manually (in try-catch blocks), log exceptions using CrashLogger methods, or re-throw the exception for catching it on main() function.

//#ifndef __CrashLoggerLib_H__
//#define __CrashLoggerLib_H__

#import <Foundation/Foundation.h>
#import "CrashLogger.h"
#import "CrashLoggerUtilities.h"

#define CRLCurrentLineInfo ([[NSString alloc] initWithFormat:@"Function: %s\nLine: %d\nFile: %s",__PRETTY_FUNCTION__, __LINE__, __FILE__])

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

//#endif /* CrashLoggerLib.h */