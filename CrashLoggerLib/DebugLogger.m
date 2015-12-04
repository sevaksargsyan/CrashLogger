//
//  DebugLogger.m
//  CrashLogger
//
//  Created by Intern on 12/4/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import "DebugLogger.h"

@implementation DebugLogger

- (BOOL) handle: (NSString*) log{
    NSLog(@"%@", log);
    return true;
}

@end
