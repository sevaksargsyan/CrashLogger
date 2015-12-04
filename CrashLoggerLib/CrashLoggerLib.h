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

#import <Foundation/Foundation.h>
#import "CrashLogger.h"
#import "CrashLoggerUtilities.h"

#define CRLCurrentLineInfo ([[NSString alloc] initWithFormat:@"Function: %s\nLine: %d\nFile: %s",__PRETTY_FUNCTION__, __LINE__, __FILE__])
#define CRLCurrentCallStack ([NSThread callStackSymbols])
#define CRLCurrentCallStackAdresses ([NSThread callStackReturnAddresses])
#define CRL [CrashLogger sharedInstance]