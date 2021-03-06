//
//  AppDelegate.h
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 12/12/11.
//  Copyright (c) 2011 Nathaniel Meierpolys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Wrapper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    ViewController *rootViewController;
    Wrapper *engine;
}

void uncaughtExceptionHandler(NSException *exception);

@property (strong, nonatomic) UIWindow *window;

@end
