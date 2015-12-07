//
//  ServerLogger.h
//  CrashLogger
//
//  Created by Intern on 12/4/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogHandlingProtocol.h"

@interface ServerLogger : NSObject <LogHandlingProtocol>

- (BOOL) handle: (NSString*) log;
- (BOOL) handleObject: (id) object;

@end
