//
//  CrashLoggerUtilities.m
//  CrashLogger
//
//  Created by SS on 12/2/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/NSException.h>
#import "CrashLoggerUtilities.h"

@implementation CrashLoggerUtilities

// Convert NSException to string. Returns nil on failure
+ (NSString*) NSExceptionToString: (NSException*) exception {
    if (exception==nil) return nil;
    
    // Converting array of call-stack lines into formatted string (using Fast Enumeration and integer is faster than traditional objectAtIndex)
    NSMutableString * strCallStackSymbols =[[NSMutableString alloc] init];
    for (NSString* callStackSymbol in exception.callStackSymbols)
    {
        [strCallStackSymbols appendFormat:@"%@\n", callStackSymbol];
    }
    
    // Converting array of call-stack return addresses into formatted string
    NSMutableString * strCallStack =[[NSMutableString alloc] init];
    NSUInteger callStackIndex=0;
    for (NSNumber* callStackReturnAddress in exception.callStackReturnAddresses)
    {
        [strCallStack appendFormat:@"%lu) %qX ",callStackIndex,[callStackReturnAddress longLongValue]];
        callStackIndex++;
    }
    
    // Constructing full exception string info
    NSMutableString* exceptionString=[[NSMutableString alloc] initWithFormat:
                                      @"Name: %@\n"
                                      "Reason: %@\n"
                                      "User info: %@\n"
                                      "Throwed exception type: %@\n"
                                      "Functions stack:\n%@\n"
                                      "Call stack's return addresses:\n%@\n",
                                      exception.name, exception.reason, exception.userInfo, exception.class, strCallStackSymbols, strCallStack];
    //exception.name, exception.reason, exception.userInfo, exception.class, exception.callStackSymbols, exception.callStackReturnAddresses]; // Non-formatted style
    
    /*// Constructing full exception string info (Short info
    NSMutableString* exceptionString=[[NSMutableString alloc] initWithFormat:
                                      @"Name: %@\n"
                                      "Reason: %@\n"
                                      "User info: %@\n"
                                      "Throwed exception type: %@\n"
                                      "Call stack's return addresses:\n%@\n",
                                      exception.name, exception.reason, exception.userInfo, exception.class, strCallStack];
    */
    return exceptionString;
}


// Tries to convert (exception) object to string. Returns nil on failure
+ (NSString*) ConvertToString: (id) object {
    if (object==nil) return nil;
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    if ([object isKindOfClass:[NSException class]]){
        return [self NSExceptionToString:object];
    }
    
    return nil;
}
@end