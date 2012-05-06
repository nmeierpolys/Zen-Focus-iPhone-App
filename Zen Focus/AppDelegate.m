//
//  AppDelegate.m
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 12/12/11.
//  Copyright (c) 2011 Nathaniel Meierpolys. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Wrapper.h"
#import "APIWorker.h"
#import "FlurryAnalytics.h"
#import "Appirater.h"

@implementation AppDelegate

@synthesize window = _window;

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:[exception name] exception:exception];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Set up exception handler
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    
    UINavigationController *navigationController = (UINavigationController *)_window.rootViewController;
    
    
    // Override point for customization after application launch.
    //rootViewController = (ViewController *)[_window rootViewController];
        
    rootViewController = (ViewController *)[navigationController topViewController];
    
    //Start Flurry session
    [FlurryAnalytics startSession:@"6WR6JDNT2FQIRJBL1DD5"];
    
    //Attach Flurry to log page views on the navigation controller
    [FlurryAnalytics logAllPageViews:navigationController];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    //APIWorker *APIobj = [[APIWorker alloc] init];
    //[APIobj sendIDInfo:@"ZenFocus"];
    [Appirater appLaunched:YES];
    
    return YES;
} 

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [rootViewController enteringBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    //APIWorker *APIobj = [[APIWorker alloc] init];
    //[APIobj sendIDInfo:@"ZenFocus"];
    [rootViewController enteringForeground];
    [Appirater appEnteredForeground:YES];
}

@end
