//
//  Task.h
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *dateStarted;
@property bool completed;

@end
