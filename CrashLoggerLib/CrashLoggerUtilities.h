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

// Convert NSException to string. Returns nil on failure
+ (NSString*) NSExceptionToString: (NSException*) exception;

// Tries to convert (exception) object to string. Returns nil on failure
+ (NSString*) ConvertToString: (id) object;

@end
