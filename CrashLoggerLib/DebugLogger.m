//
//  DebugLogger.m
//  CrashLogger
//
//  Created by SS on 12/4/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import "DebugLogger.h"
#import "CrashLoggerUtilities.h"

@implementation DebugLogger

- (BOOL) handle:(NSString *)log withLevel:(CRLLogLevel)level withKey:(NSString *)key {
    NSString * str;
    if (key!=nil && ![key isEqualToString:@""]){
        NSLog(@"%@: %@",key,log);
    } else if (level!=0) {
        switch (level) {
            case Critical:
                str=@"Critical: ";
                break;
            case Error:
                str=@"Error: ";
                break;
            case Warning:
                str=@"Warning: ";
                break;
            case Info:
                str=@"";//@"Info: ";
                break;
            case Debug:
                str=@"Debug: ";
                break;
            default:
                str=@"";
                break;
        }
        NSLog(@"%@%@", str,log);
    } else {
        NSLog(@"%@",log);
    }
    return true;
}

- (BOOL) handleObject:(id)object withLevel:(CRLLogLevel)level withKey:(NSString *)key {
    NSString* str=nil;
    
    // If it's NSException (or derived type), then convert it to string and log as string
    if ([object isKindOfClass:[NSException class]]){
        str=[CrashLoggerUtilities NSExceptionToString:object];
    } else {
        // Otherwise, try to convert the unknown type to string
        str=[CrashLoggerUtilities ConvertToString:object];
    }
    
    // If conversion was not successfull, then warn about it
    if (str==nil){
        str=[NSString stringWithFormat:@"Unknown exception/object of type: %@", NSStringFromClass([object class])];
    }
    
    return [self handle:str withLevel:level withKey:key];
}

@end
