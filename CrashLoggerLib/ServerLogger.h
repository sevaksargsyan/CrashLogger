//
//  ServerLogger.h
//  CrashLogger
//
//  Created by SS on 12/4/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogHandlerProtocol.h"

@interface ServerLogger : NSObject <LogHandlingProtocol>

- (BOOL) handle:(NSString *)log withLevel:(CRLLogLevel)level withKey:(NSString *)key;
- (BOOL) handleObject:(id)object withLevel:(CRLLogLevel)level withKey:(NSString *)key;

@end
