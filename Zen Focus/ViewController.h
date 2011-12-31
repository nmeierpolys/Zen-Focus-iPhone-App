//
//  ViewController.h
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 12/12/11.
//  Copyright (c) 2011 Nathaniel Meierpolys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSString *taskPrompt;
    bool updateTimer;
    
    NSTimeInterval remainingTime;
    NSTimeInterval interval;
    
    NSDate *endingInstant;
    NSDate *startingInstant;
}

@property (weak, nonatomic) IBOutlet UIView *taskView;
@property (weak, nonatomic) IBOutlet UITextView *textTask;
@property (weak, nonatomic) IBOutlet UITextField *textTime;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;
@property (weak, nonatomic) IBOutlet UIView *viewControls;

- (IBAction)buttonReset:(id)sender;
- (IBAction)buttonStart:(id)sender;
- (IBAction)buttonInfo:(id)sender;

- (void)updateTimeField;
- (void)enteringBackground;
- (void)enteringForeground;
- (void)loadDefaults;

- (NSString *)timeTextFromInterval:(NSTimeInterval)interval;

@end
