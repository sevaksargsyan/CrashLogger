//
//  CrashLoggerUtilities.m
//  CrashLogger
//
//  Created by SS on 12/2/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import "CrashLoggerUtilities.h"

@interface CrashLoggerUtilities (){
    
}
@end

@implementation CrashLoggerUtilities

+ (NSString*) NSExceptionToString: (NSException*) exception {
    
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
    
    return exceptionString;
}
@end