//
//  ViewController.m
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 12/12/11.
//  Copyright (c) 2011 Nathaniel Meierpolys. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController
@synthesize taskView = _taskView;
@synthesize textTime = _textTime;
@synthesize imageBackground = _imageBackground;
@synthesize viewControls = _viewControls;
@synthesize textTask = _textTask;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


// ======== View events ========

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDefaults];
    
    remainingTime = interval;  
    updateTimer = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeField) userInfo:nil repeats:YES];
    
    taskPrompt = @"What will you do?";
    
    self.textTime.text = [self timeTextFromInterval:interval];
    self.textTask.layer.cornerRadius = 5;
    self.textTask.layer.borderColor = [UIColor grayColor].CGColor;
    self.textTask.layer.borderWidth = 1.0f;
}
- (void)viewDidUnload
{
    [self setTextTask:nil];
    [self setTextTime:nil];
    [self setTaskView:nil];
    [self setImageBackground:nil];
    [self setViewControls:nil];
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}


- (void)enteringBackground{
    if(!updateTimer)
        return;
    
    //cache instant when the task should expire
    endingInstant = [[NSDate alloc] initWithTimeIntervalSinceNow:remainingTime];
    
}

- (void)enteringForeground{
    [self loadDefaults];
    
    if(!updateTimer)
        return;
    //Test change for github
    //restore instant when the task should expire
    remainingTime = [endingInstant timeIntervalSinceNow];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        //Landscape
        //self.imageBackground.frame = CGRectMake(193,150,574,320);
        //self.textTask.frame = CGRectMake(240,150,344,109);
        //self.viewControls.frame = CGRectMake(240,262,243,73);
        self.textTask.frame = CGRectMake(self.textTask.frame.origin.x, self.textTask.frame.origin.y, self.textTask.frame.size.width, self.textTask.frame.size.height / 2);
    }
    else
    {
        //Portrait
        //self.imageBackground.frame = CGRectMake(61,230,518,460);
        //self.textTask.frame = CGRectMake(140,62,280,124);
        //self.viewControls.frame = CGRectMake(160,392,243,73);
        self.textTask.frame = CGRectMake(self.textTask.frame.origin.x, self.textTask.frame.origin.y, self.textTask.frame.size.width, self.textTask.frame.size.height * 2);
    }
}

// ======== Real logic methods ========
- (void) loadDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    double numMinutes = [[defaults stringForKey:@"duration"] doubleValue];
    if(numMinutes == 0)
        numMinutes = 25;
    
    interval = numMinutes * 60;
    self.textTime.text = [self timeTextFromInterval:interval];
}

- (void)updateTimeField {
    if(!updateTimer)
        return;
    
    if(remainingTime <= 0)
    {
        self.textTime.text = [self timeTextFromInterval:0];
        updateTimer = NO;
        return;
    }
    
    remainingTime = remainingTime - 1;
    self.textTime.text = [self timeTextFromInterval:remainingTime];
}

- (NSString *)timeTextFromInterval:(NSTimeInterval)timeInterval{
    int minutes = floor(timeInterval/60);
    int seconds = trunc(timeInterval - (minutes * 60));
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}



// ======== Button events ========
- (IBAction)buttonStart:(id)sender {  
    
    if(!updateTimer){  
        
        //Starting the timer - add a local alert notification for the end time
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        NSDate *fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:remainingTime];
        
        localNotification.fireDate = fireDate;
        localNotification.alertBody = [NSString stringWithFormat:@"Task: %@\nTime's up, take a break",   self.textTask.text];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; 
        
    } else {
        
        //Stopping the timer - notification time is no longer valid so clear it
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
    }
    
    updateTimer = !updateTimer;
}

- (IBAction)buttonReset:(id)sender {
    remainingTime = interval;
    self.textTime.text = [self timeTextFromInterval:interval];
    updateTimer = NO;
}

- (IBAction)buttonInfo:(id)sender {
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Zen Focus" message:@"Create a task and get to it. It's as simple as that." delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil,nil];
    [alert show];
}



// ======== Text view methods ========
-(BOOL)textViewShouldBeginEditing:(UITextView *)editingTextView{
    editingTextView.text = @"";
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)editingTextView{
    if([editingTextView.text isEqualToString:@""])
        editingTextView.text = taskPrompt;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    //Hide keyboard when done
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}

@end
