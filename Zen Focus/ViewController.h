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
    bool keyboardUp;
    
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
@property (weak, nonatomic) IBOutlet UILabel *restartLabel;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (nonatomic, strong) NSArray *tasks;
@property (weak, nonatomic) IBOutlet UIView *MainView;

- (IBAction)buttonReset:(id)sender;
- (IBAction)buttonStart:(id)sender;
- (IBAction)buttonInfo:(id)sender;

- (void)updateTimeField;
- (void)enteringBackground;
- (void)enteringForeground;
- (void)loadDefaults;
- (void)fadeCaptionsIn;
- (void)fadeCaptionsOut;
- (void)fadeCaptionsOutTimer: (NSTimer *)theTimer;
- (void)animateTextView:(bool)up;
- (void)addTaskComponentsToArray:(NSString *)title dateStarted:(NSDate *)dateStarted completed:(bool)completed;
- (NSString *)timeTextFromInterval:(NSTimeInterval)interval;
- (void)addCurrentTaskComponentsToArray:(bool)completed;
- (void)loadPlistEntries;
- (NSString *)plistPath;

@end
