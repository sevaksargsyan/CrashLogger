//
//  LogHandlingProtocol.h
//  CrashLogger
//
//  Created by SS on 12/3/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>

// Log levels
typedef NS_OPTIONS(NSUInteger, CRLLogLevel) {
    None        = 0,
    All         = NSUIntegerMax,
    
    Critical    = 1 << 0,   // Critical cases, such as system-level or low-level crashes, which can't be handled
    Error       = 1 << 1,   // Exceptions and errors
    Warning     = 1 << 2,   // Warnings, which can be handled or ignored if necessary
    Info        = 1 << 3,   // Information, which should be logged. Use CustomEvent when logging more specific info
    
    Debug       = 1 << 4,   // Debug info, for development purposes
    //CustomKey   = 1 << 5    // Custom events, for logging specific events such as custom warning or stastics
};

@protocol LogHandlingProtocol <NSObject>

@required

//- (BOOL) handle: (NSString*) log;
//- (BOOL) handleObject: (id) object;

- (BOOL) handle: (NSString*) log withLevel: (CRLLogLevel) level withKey: (NSString*) key;
- (BOOL) handleObject: (id) object withLevel: (CRLLogLevel) level withKey: (NSString*) key;

@optional   // Note: Remember to check if [object respondsToSelector] before calling these methods.

- (BOOL) handleNSException: (NSException*) exception;
- (BOOL) handleNSError: (NSError*) error;

@end
