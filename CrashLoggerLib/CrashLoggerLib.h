//
//  CrashLogger
//  -----------
//
//      CrashLogger - crash logging, handling and reporting library.
//      Created by SSargsyan. Copyright © Macadamian, 2015.
//
//  General notes:
//  --------------
//      o Import CrashLoggerLib.h into the program, register log handlers, and set exception catchers
//      o Use CrashLogger's custom NSLog-like methods for logging
//      o To create custom log handlers (e.g for sending to server asynchronously), create a class and conform <LogHandlingProtocol>
//      o Use safe CrashLogger blocks to catch exceptions in place
//      o When catching exceptions manually (in try-catch blocks), log exceptions using CrashLogger methods, or re-throw the exception for catching it on main() function.

#import <Foundation/Foundation.h>

#import "CrashLogger.h"

// Get current function name, file name and current line
#define CRLCurrentLineInfo ([[NSString alloc] initWithFormat:@"Function: %s\nLine: %d\nFile: %s",__PRETTY_FUNCTION__, __LINE__, __FILE__])
// Get current call stack, function names and their addresses in stack
#define CRLCurrentCallStack ([NSThread callStackSymbols])
// Get current call stack return addresses
#define CRLCurrentCallStackAdresses ([NSThread callStackReturnAddresses])

// Shortcut to CrashLogger's singleton instance
#define CRL [CrashLogger sharedInstance]