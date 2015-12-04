//
//  LogHandlingProtocol.h
//  CrashLogger
//
//  Created by SS on 12/3/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogHandlingProtocol <NSObject>

#pragma mark - Required methods and properties

@required

- (BOOL) handle: (NSString*) log;

#pragma mark - Optional methods and properties
@optional // Note: Remember to check if [object respondsToSelector] before calling these methods.
- (BOOL) handleNSException: (NSException*) exception;
- (BOOL) handleNSError: (NSError*) error;

@end
