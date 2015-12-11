//
//  CrashLogger.h
//  CrashLogger
//
//  Created by SS on 12/3/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogHandlerProtocol.h"

@interface CrashLogger : NSObject

#pragma mark - Initialization and singleton

+ (instancetype) sharedInstance;                                            // Shared instance of singleton class
- (instancetype) init __attribute__((unavailable("use sharedInstance")));   // Init method call prevention - for preventing non-singleton instance creation

#pragma mark - Log handler registration

/** Registers log handler with the given name, logging levels and custom keys. Then log handler will only receive logs of given levels and keys. */
- (BOOL) registerLogHandler: (id <LogHandlingProtocol>) logHandler withName:(NSString*) name forEventLevels:(CRLLogLevel) eventLevels forCustomKeys:(NSArray*) keys;

/** Unregisters log handler */
- (BOOL) unregisterLogHandler: (NSString*) handlerName;

// Short/convenient methods

/** Registers log handler with the given name which will receive all logs. Use extended method to filter log event levels and custom keys. */
- (BOOL) registerLogHandler: (id <LogHandlingProtocol>) logHandler withName:(NSString*) name;

#pragma mark - Logging methods

// General methods - all above mentioned methods call these methods
/** Logs text with given level (Critical, Error, Warning, Info, Debug), custom key and format. If key parameter was set, then level may be omitted. */
 - (void) logWithLevel:(CRLLogLevel) level withKey:(NSString*) key withFormat: (NSString*) format,...;
/** Logs object (such as NSException) with given level (Critical, Error, Warning, Info, Debug) and custom key. If key parameter was set, then level may be omitted. */
- (void) logWithLevel:(CRLLogLevel) level withKey:(NSString*) key object: (id) info;

// Short/convenient methods

/** Logs formatted text like NSLog. Log level is set to 'Info', key is set to nil */
- (void) log: (NSString*) format,...;
/** Logs object (such as NSException, NSError) */
- (void) logObject: (id) object;

/** Logs formatted text with the given log level (Critical, Error, Warning, Info, Debug) */
- (void) logWithLevel: (CRLLogLevel) level format:(NSString*) format,...;
/** Logs object (such as NSException, NSError) with the given log level (Critical, Error, Warning, Info, Debug) */
- (void) logWithLevel: (CRLLogLevel) level object:(id) object;

/** Logs formatted text with the given custom key */
- (void) logWithKey: (NSString*) customKey format:(NSString*) format,...;
/** Logs object (such as NSException, NSError) with the given custom key */
- (void) logWithKey: (NSString*) customKey object:(id) object;

#pragma mark - Global uncaught exception Handler

/**
 Returns pointer to CrashLogger's function which can handle global exceptions. 
 Handler will catch all exceptions and automatically log them.
 Set it as global handler using NSSetUncaughtExceptionHandler([... uncaughtExceptionHandler]) from functions [application:didFinish] or from main (before "return").
 */
- (NSUncaughtExceptionHandler*) uncaughtExceptionHandler;

#pragma mark - Safe blocks

/** Safely executes the block and logs exceptions */
+ (void)safeBlock:(void(^)(void))block;

@end
