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
+ (NSString*) NSExceptionToString: (NSException*) exception;
@end
