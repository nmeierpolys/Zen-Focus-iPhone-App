//
//  APIWorker.h
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wrapper.h"

@interface APIWorker : NSObject
{
    Wrapper *engine;
}

- (void)sendInfoToAPI:(NSDictionary *)parameters toUrl:(NSString *)url;
- (void)sendIDInfo:(NSString *)appName;

@end
