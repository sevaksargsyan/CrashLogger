//
//  CrashLogger.m
//  CrashLogger
//
//  Created by SS on 12/3/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import "CrashLogger.h"
#import "LogHandlerInfo.h"

@interface CrashLogger()

@property NSMutableArray* logHandlers;

@end

@implementation CrashLogger

#pragma mark - Singleton creation and initialization

+ (instancetype)sharedInstance {
    static CrashLogger * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (!self) return self;
    
    // Initialize properties here
    NSLog(@"Initializing CrashLogger...");
    _logHandlers=[[NSMutableArray alloc] init];
    
    return self;
}

#pragma mark - Log handler registration

- (BOOL) registerLogHandler:(id<LogHandlingProtocol>)logHandler withName:(NSString *)name {
    return [self registerLogHandler:logHandler withName:name forEventLevels:All forCustomKeys:@[@"*"]];
}

- (BOOL) registerLogHandler: (id <LogHandlingProtocol>) logHandler withName:(NSString*) name forEventLevels:(CRLLogLevel) eventLevels forCustomKeys:(NSArray*) keys {
    // Check parameters and disallow nil for log handlers, disallow "*" for name (because it may be used as wildcard)
    if (logHandler==nil) {
        NSLog(@"...");
        return false;
    }
    if ([name isEqualToString:@"*"]) {
        NSLog(@"...");
        return false;
    }
    
    // Check, if handler name already exists then warn and return false
    for (LogHandlerInfo* handlerInfo in _logHandlers){
        if ([handlerInfo.name isEqualToString:name]){
            // Handler with the same name already exists. Check if it's the same handler or not and warn.
            if (handlerInfo.handler==logHandler){
                NSLog(@"WARNING: Tried to register the same log handler.\nSkipping registration.\n"
                      "1) Make sure you want to register the same log handler.\n"
                      "2) If necessary, register with another name.\n");
            } else {
                NSLog(@"WARNING: Handler with this name is already registered. Skipping registration.\n"
                      "1) Register with another handler name\n"
                      "2) Unregister previous log handler and register this one\n");
            }
            return false;
        }
    }
    
    // Register log handler
    LogHandlerInfo* handlerInfo = [[LogHandlerInfo alloc] init];
    handlerInfo.name=name;
    handlerInfo.handler=logHandler;
    handlerInfo.respondsToLogLevels=eventLevels;
    handlerInfo.respondsToLogKeys=keys;
    [_logHandlers addObject:handlerInfo];
    
    return true;
}

- (BOOL) unregisterLogHandler: (NSString*) handlerName {
    // If parameter is wildcard "*" then remove all handlers
    if ([handlerName isEqualToString:@"*"]){
        [_logHandlers removeAllObjects];
        return true;
    }
    
    // Check if handler exists, then remove handler and return true. No need to check next items because handler name is unique
    for (NSUInteger i=0; i<_logHandlers.count; ++i){
        if ([[[_logHandlers objectAtIndex:i] name] isEqualToString:handlerName]){
            [_logHandlers removeObjectAtIndex:i];
            return true;
        }
    }
    
    // If it doesn't exist then warn and return false
    NSLog(@"WARNING: Tried to unregister non-existing log handler ID.\nSkipping unregistration.");
    return false;
}

#pragma mark - Logging methods

- (void) logWithLevel:(CRLLogLevel)level withKey:(NSString *)key withFormat:(NSString *)format, ... {
    // Convert formatted text to normal text and pass to logger
    va_list args;
    va_start(args, format);
    NSString * str=[[NSString alloc]initWithFormat:format arguments:args];
    [self logWithLevel:level withKey:key object:str];
    va_end(args);
}

- (void)logWithLevel:(CRLLogLevel)level withKey:(NSString *)key object:(id) info {
    // Check if there's no log handler, then warn and return
    if (_logHandlers.count==0){
        NSLog(@"WARNING: Tried to log without log handlers. Log will be skipped.\n"
              "Register log handlers before logging info.");
        return;
    }
    
    // Iterate through log handlers and send them log for handling
    BOOL loggedInfoWasHandledOnce = false;
    id <LogHandlingProtocol> handler=nil;
    for (LogHandlerInfo* handlerInfo in _logHandlers){
        handler=handlerInfo.handler;
        // Check if handler is empty
        if (handler==nil){
            // If handler is nil, then it was nil-ed after registration, because we don't allow registering nil handler
            NSLog(@"WARNING: Encountered empty (nil) log handler. Skipping it.\n"
                  "Handler was emptied after registration.\n"
                  "1) Check if log handler was unallocated somewhere (after registration)\n"
                  "2) Unregister log handler before unallocating it (by using unregisterLogHandler method)");
            continue;
        }
        
        // Check, if handler doesn't accept the given key or log level, then skip it
        if (! ([handlerInfo.respondsToLogKeys containsObject:key]==true ||
               [handlerInfo.respondsToLogKeys containsObject:@"*"] ||
               ((handlerInfo.respondsToLogLevels && level) > 0) )){
            continue;
        }
    
        // If info type is string (or derives from it, such as NSMutableString) then pass it to log string handler
        if ([info isKindOfClass:NSString.class]){
            if ([handler respondsToSelector:@selector(handle:withLevel:withKey:)]){
                [handler handle:info withLevel:level withKey:key];
            } else {
                NSLog(@"WARNING: Can't pass information to log handler.\n"
                      "Log handler did not respond to selector 'handle'.\n"
                      "Make sure log handler is correct and conforms to log handling protocol.\n");
                continue; // Comment this line = try to pass to next handling functions
            }
            
        // Log info of other (non-string) types. They will be passed as "id" to handler's handleObject method.
        } else {
            if ([handler respondsToSelector:@selector(handleObject:withLevel:withKey:)]){
                [handler handleObject:info withLevel:level withKey:key];
            } else {
                NSLog(@"WARNING: Can't pass information to log handler.\n"
                      "Log handler did not respond to selector 'handle'.\n"
                      "Make sure log handler is correct and conforms to log handling protocol.\n");
                continue; // Comment this line = try to pass to other handling functions
            }
        }
        loggedInfoWasHandledOnce=true;
    }
    
    // Check if log was handled. If no handler handled it, then warn about it
    if (loggedInfoWasHandledOnce==false) {
        NSLog(@"WARNING: Logged information was not handled by any log handler.\n"
              "1) Make sure log key is valid and there are handlers which accept the log key.\n"
              "2) Check if log level is correct.");
        return;
    }
}

#pragma mark - Log methods (short, convenient)

- (void) log:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    NSString * str=[[NSString alloc]initWithFormat:format arguments:args];
    [self logWithLevel:Info withKey:nil object:str];
    va_end(args);
}

- (void) logObject:(id)object {
    [self logWithLevel:Info withKey:nil object:object];
}

- (void) logWithLevel: (CRLLogLevel) level format:(NSString*) format,... {
    va_list args;
    va_start(args, format);
    NSString * str=[[NSString alloc]initWithFormat:format arguments:args];
    [self logWithLevel:level withKey:nil object:str];
    va_end(args);
}

- (void) logWithLevel: (CRLLogLevel) level object:(id) object {
    [self logWithLevel:level withKey:nil object:object];
}

- (void) logWithKey: (NSString*) customKey format:(NSString*) format,... {
    va_list args;
    va_start(args, format);
    NSString * str=[[NSString alloc]initWithFormat:format arguments:args];
    [self logWithLevel:None withKey:customKey object:str];
    va_end(args);
}

- (void) logWithKey: (NSString*) customKey object:(id) object {
    [self logWithLevel:None withKey:customKey object:object];
}

#pragma mark - Global uncaught exception Handler

// Handling uncaught exceptions here
void _uncaughtExceptionHandler(NSException* exception) {
    [[CrashLogger sharedInstance] logWithLevel:Error withKey:nil object:exception];
    // There are three ways: 1) exit() here and don't wait for crash, 2) don't exit(), catch signal SIGABRT and handle it, 3) don't exit() and crash
    // exit(0);
}

// Objective-C style wrapper for C-style function _uncaughtExceptionHandler(). Returns pointer function's pointer. Note: for handling exceptions, go to _uncaughtExceptionHandler function
- (NSUncaughtExceptionHandler*) uncaughtExceptionHandler{
    return &_uncaughtExceptionHandler;
}

#pragma mark - Safe blocks
+ (void)safeBlock:(void(^)(void))block{
    // Catching uncaught exceptions. Uncaught exceptions go up in exception handling chain, and if there's no exception handler, they reach this function and get caught there.
    @try {
        block();
    }
    @catch (NSString* exception){
        [[CrashLogger sharedInstance] logWithLevel:Error withKey:nil object:exception];
    }
    // Catch other exception types which are compatible with id type (such as NSObject, NSError). Logging their classes.
    @catch (id exception){
        [[CrashLogger sharedInstance] logWithLevel:Error withKey:nil object:exception];
    }
    // Catch other exception types. This case should never happen as @throw only accepts object types. If it happens take care carefully
    @catch (...){
        [[CrashLogger sharedInstance] logWithLevel:Error withKey:nil withFormat:@"Unhandled exception of unknown type"];
    }
}

@end
