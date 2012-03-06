//
//  Controller.m
//  iPhoneWrapperTest
//
//  Created by Adrian on 11/18/08.
//  Copyright netinfluence 2008. All rights reserved.
//

#import "Controller.h"
#import "Wrapper.h"

@implementation Controller

- (void)dealloc 
{
    engine = nil;
    picker = nil;
}

#pragma mark -
#pragma mark WrapperDelegate methods

- (void)wrapper:(Wrapper *)wrapper didRetrieveData:(NSData *)data
{
    NSString *text = [engine responseAsText];
    if (text != nil)
    {
        output.text = text;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark IBAction methods

- (IBAction)launch:(id)sender
{
    [address resignFirstResponder];
    [parameter resignFirstResponder];

    NSURL *url = [NSURL URLWithString:@"http://www.thanscorner.info/iPhoneAPI/index.php"];
    
    NSDictionary *parameters = nil;
    NSArray *keys = [NSArray arrayWithObjects:
                     @"Timestamp", 
                     @"Version", 
                     @"DeviceType",
                     @"IPAddress",
                     nil];
    NSArray *values = [NSArray arrayWithObjects:
                       @"Test 1", 
                       @"Test 2", 
                       @"Test 3", 
                       @"Test 4", 
                       nil];
    parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    if (engine == nil)
    {
        engine = [[Wrapper alloc] init];
        engine.delegate = self;
    }
    [engine sendRequestTo:url usingVerb:[popUpButton titleForState:UIControlStateNormal] withParameters:parameters];
}

@end
