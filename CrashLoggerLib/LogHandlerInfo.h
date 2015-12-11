//
//  LogHandlerInfo.h
//  CrashLogger
//
//  Created by SS on 12/9/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogHandlerProtocol.h"

@interface LogHandlerInfo : NSObject

@property NSString *    name;
@property CRLLogLevel   respondsToLogLevels;
@property NSArray *     respondsToLogKeys;
@property id <LogHandlingProtocol> handler;

@end
