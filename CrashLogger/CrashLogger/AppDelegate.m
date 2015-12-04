//
//  AppDelegate.m
//  CrashLogger
//
//  Created by SS on 12/1/15.
//  Copyright © 2015 Macadamian. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

#import <Foundation/Foundation.h>
#import <Foundation/NSException.h>
#import "CrashLoggerLib.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


// Global uncaught exception handler
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"!!! Caught global uncaught exception.\nHere is full exception information about exception,\n which we can log now or send to server:\n");
    NSLog(@"%@\n", [CrashLoggerUtilities NSExceptionToString:exception]);
    NSLog(@"Exception was caught successfully.\n Now it will rethrow the exception, and next lines will be repeating");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    return YES;
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    NSLog(@"\nCausing crash from:\n%@\n\n",CRLCurrentLineInfo);
    // Causing crashes of different types (Move these to CrashLoggerLib). Uncomment one of them to crash and check the logs.
    [[[NSArray alloc] init] objectAtIndex:2];   // Out of array bounds. Will throw NSException.
    //@throw @"Throwed NSString(NSObject,id)";  // Throw NSString, which is NSObject,id. So catch(id) will catch it because it's id-type.
    //@throw [[[NSString class] alloc] init];   // Check if class has alloc, init methods (!), then throw exceptions of any type like this, for example, [[[anyClassHere class] alloc] init]
    
    // Log call stack at any time
    //NSLog(@"Call stack:\n%@\n\n%@\n",[NSThread callStackSymbols],[NSThread callStackReturnAddresses]);
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Other application events


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
