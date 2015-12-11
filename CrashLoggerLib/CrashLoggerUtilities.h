//
//  CrashLoggerUtilities.h
//  CrashLogger
//
//  Created by SS on 12/2/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSException.h>

@interface CrashLoggerUtilities : NSObject

/** Converts NSException to readable formatted string. Returns nil on failure */
+ (NSString*) NSExceptionToString: (NSException*) exception;

/** Converts NSError to readable formatted string. Returns nil on failure */
+ (NSString*) NSErrorToString: (NSError*) error;

/** Converts known objects (NSException, NSError, NSString) to string. Returns nil on failure */
+ (NSString*) ConvertToString: (id) object;

@end