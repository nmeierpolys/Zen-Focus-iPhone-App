//
//  MyTableViewController.h
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 1/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface MyTableViewController : UITableViewController
- (IBAction)btnClear:(id)sender;
@property (nonatomic, strong) NSArray *tasks; //array of task strings
@property (nonatomic, strong) ViewController *caller;
@end
