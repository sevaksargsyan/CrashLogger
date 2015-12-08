//
//  DebugLogger.m
//  CrashLogger
//
//  Created by Intern on 12/4/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import "DebugLogger.h"
#import "CrashLoggerUtilities.h"

@implementation DebugLogger

- (BOOL) handle: (NSString*) log{
    NSLog(@"%@", log);
    return true;
}

- (BOOL) handleObject:(id)object{
    
    // If it's NSException, then convert it to string and log as string
    if ([object isMemberOfClass:[NSException class]]){
        return [self handle:[CrashLoggerUtilities NSExceptionToString:object]];
    } else {
    // Otherwise, try to convert the unknown type to string
        NSString* str=nil;
        str=[CrashLoggerUtilities ConvertToString:object];
        
        if (str!=nil) {
            return [self handle:str];
        } else {
            return [self handle:[NSString stringWithFormat:@"Unknown exception/object of type %@", NSStringFromClass([object class])]];
        }
    }
    
    return false;
}

@end
