//
//  AppDelegate.m
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 12/12/11.
//  Copyright (c) 2011 Nathaniel Meierpolys. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    // Override point for customization after application launch.
    //rootViewController = (ViewController *)[_window rootViewController];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    rootViewController = (ViewController *)[navigationController topViewController];
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
    [rootViewController enteringForeground];
}

@end
