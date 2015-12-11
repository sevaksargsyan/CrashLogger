//
//  DebugLogger.h
//  CrashLogger
//
//  Created by SS on 12/4/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogHandlerProtocol.h"

@interface DebugLogger : NSObject <LogHandlingProtocol>

/*
- (BOOL) handle: (NSString*) log;
- (BOOL) handleObject: (id) object;
*/

- (BOOL) handle: (NSString *) log withLevel:(CRLLogLevel)level withKey:(NSString *)key;
- (BOOL) handleObject:(id) object withLevel:(CRLLogLevel)level withKey:(NSString *)key;

@end
