//
//  APIWorker.m
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "APIWorker.h"

@implementation APIWorker

- (id)init
{
    if(self = [super init])
    {
        if (engine == nil)
        {
            engine = [[Wrapper alloc] init];
        }
    }
    
    return self;
}

- (void)sendInfoToAPI:(NSDictionary *)parameters toUrl:(NSString *)url
{
    NSURL *urlObj = [NSURL URLWithString:url];
    
    if (engine == nil)
    {
        engine = [[Wrapper alloc] init];
    }
    [engine sendRequestTo:urlObj usingVerb:@"GET" withParameters:parameters];
}

- (void)sendIDInfo:(NSString *)appName
{
    NSString *deviceType;
    NSString *version;
    NSString *timestamp;
    NSString *appVersion;
    
    //Device type
    deviceType = [UIDevice currentDevice].model;
    version = [[UIDevice currentDevice] systemVersion];
    
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy - hh:mm:ss"];
    timestamp = [dateFormatter stringFromDate:currentDate];
    
    appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *urlStr = @"http://www.thanscorner.info/iPhoneAPI/index.php";
    NSDictionary *parameters = [[NSDictionary alloc] init ];
    NSArray *keys = [NSArray arrayWithObjects:
                     @"DeviceType",
                     @"Version",
                     @"Timestamp",
                     @"AppVersion",
                     @"AppName",
                     nil];
    NSArray *values = [NSArray arrayWithObjects:
                       deviceType,
                       version,
                       timestamp,
                       appVersion,
                       appName,
                       nil];
    parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    [self sendInfoToAPI:parameters toUrl:urlStr];
}

@end
