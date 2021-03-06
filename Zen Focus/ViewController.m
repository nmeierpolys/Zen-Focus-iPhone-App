//
//  ViewController.m
//  Zen Focus
//
//  Created by Nathaniel Meierpolys on 12/12/11.
//  Copyright (c) 2011 Nathaniel Meierpolys. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewController.h"
#import "Task.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController()

@property (nonatomic) bool textIsEmpty;

@end

@implementation ViewController
@synthesize taskView = _taskView;
@synthesize textTask = _textTask;
@synthesize textTime = _textTime;
@synthesize imageBackground = _imageBackground;
@synthesize viewControls = _viewControls;
@synthesize restartLabel = _restartLabel;
@synthesize playLabel = _playLabel;
@synthesize titleView = _titleView;
@synthesize tasks = _tasks;
@synthesize MainView = _MainView;
@synthesize textIsEmpty = _textIsEmpty;

#pragma mark - View lifecycle


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// ======== View events ========

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDefaults];
    
    remainingTime = interval;  
    updateTimer = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeField) userInfo:nil repeats:YES];
    
    taskPrompt = @"What will you do?";
    self.textTask.text = taskPrompt; 
    self.textIsEmpty = YES;
    
    self.textTime.text = [self timeTextFromInterval:interval];
    self.textTask.layer.cornerRadius = 5;
    self.textTask.layer.borderColor = [UIColor grayColor].CGColor;
    self.textTask.layer.borderWidth = 1.0f;
    
    [self fadeCaptionsIn];
    [NSTimer scheduledTimerWithTimeInterval: 3.0 target:self selector:@selector(fadeCaptionsOutTimer:) userInfo:nil repeats: NO];
    
    
    self.tasks = [[NSArray alloc] init];
    
    [self loadPlistEntries];
}

- (void)viewDidUnload
{    
    [self setTextTask:nil];
    [self setTextTime:nil];
    [self setTaskView:nil];
    [self setImageBackground:nil];
    [self setViewControls:nil];
    [self setRestartLabel:nil];
    [self setPlayLabel:nil];
    [self setTitleView:nil];
    [self setMainView:nil];
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
    //Test change for github - 2
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
        
        int textYPos = 85;
        if(keyboardUp)
            textYPos -=40;
        
        self.textTask.frame = CGRectMake(20,textYPos,440,90);
        self.imageBackground.frame = CGRectMake(-295,-45,775,335);
        self.titleView.frame = CGRectMake(101,25,118,26);
        //self.viewControls.frame = CGRectMake(124,205,233,2);
    }
    else
    {
        //Portrait
        
        int textYPos = 125;
        if(keyboardUp)
            textYPos -=40;
        
        self.textTask.frame = CGRectMake(20,textYPos,280,150);
        self.imageBackground.frame = CGRectMake(-210,-45,536,520);
        self.titleView.frame = CGRectMake(101,50,114,26);
        //self.viewControls.frame = CGRectMake(44,350,233,2);
    }
}


- (NSString *)plistPath{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *plistFile = @"ZenFocusTasks";
    
    return [documentsDirectory stringByAppendingPathComponent:plistFile];
}

- (void)loadPlistEntries{
    
    //Initialize    
    NSArray *plistArr = [[NSArray alloc] init];
    
    //Plist document path
    NSString *plistPath = [self plistPath];
	
    //Populate array from plist
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        plistArr = [NSArray arrayWithContentsOfFile:plistPath];
	} else {;
        return;
	}
    
    //Look through plistArr and set up table.
    NSUInteger count = [plistArr count];
    for (NSUInteger i = 0; i < count; i++) {
        NSDictionary *taskInfo = (NSDictionary *)[plistArr objectAtIndex:i];
        
        NSString *taskTitle = [taskInfo objectForKey:@"taskTitle"];
        NSDate *dateStarted = [taskInfo objectForKey:@"taskDateStarted"];
        NSNumber *completed = [taskInfo objectForKey:@"taskCompleted"];
        bool isCompleted = [completed boolValue];
        
        [self addTaskComponentsToArray:taskTitle dateStarted:dateStarted completed:isCompleted];

    }
}

- (void)fadeCaptionsOut{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    self.restartLabel.alpha = 0;
    self.playLabel.alpha = 0;
    [UIView commitAnimations];
}

- (void)fadeCaptionsIn{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    self.restartLabel.alpha = 1;
    self.playLabel.alpha = 1;
    [UIView commitAnimations];
}

- (void)animateTextView: (bool)up{
    [UIView setAnimationDelegate:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    if(up){
        keyboardUp = true;
        self.textTask.transform = CGAffineTransformMakeTranslation (0, -40);
    } else {
        keyboardUp = false;
        self.textTask.transform = CGAffineTransformMakeTranslation (0, 0);
    }
    
    [UIView commitAnimations];
}

-(void) fadeCaptionsOutTimer: (NSTimer *)theTimer {
    [self fadeCaptionsOut];
}


// ======== Real logic methods ========
- (void) loadDefaults {
    
    [NSUserDefaults resetStandardUserDefaults];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    double numMinutes = [[defaults stringForKey:@"duration"] doubleValue];
    if(numMinutes == 0)
        numMinutes = 25;
    
    useSound = [[defaults stringForKey:@"useSound"] boolValue];
    
    int newInterval = numMinutes * 60;
    
    //If user changed the duration setting, cancel the current timer
    if(interval != newInterval)
    {
        updateTimer = false;
    
        interval = newInterval;
        remainingTime = interval;
        
        self.textTime.text = [self timeTextFromInterval:interval];
    }
    
}

- (void)updateTimeField { 
    if(!updateTimer)
        return;
    
    if(remainingTime <= 0)
    {
        self.textTime.text = [self timeTextFromInterval:0];
        updateTimer = NO;
        [self addCurrentTaskComponentsToArray:YES];
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
        
        
        //Reset if the last one expired already (remainingTime == 0)
        if(remainingTime == 0)
            remainingTime = interval;
        
        //Add a local alert notification for the end time
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        NSDate *fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:remainingTime];
        
        localNotification.fireDate = fireDate;
        localNotification.alertBody = [NSString stringWithFormat:@"Task: %@\nTime's up, take a break",   self.textTask.text];
        if(useSound)
            localNotification.soundName = @"ding.wav";
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; 
        
    } else {
        
        //Stopping the timer - notification time is no longer valid so clear it
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
    }
    
    updateTimer = !updateTimer;
}

- (IBAction)buttonReset:(id)sender {
    [self addCurrentTaskComponentsToArray:NO];
    
    remainingTime = interval;
    self.textTime.text = [self timeTextFromInterval:interval];
    updateTimer = NO;
}

- (IBAction)buttonInfo:(id)sender {
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Zen Focus" message:@"Create a task and get to it. It's as simple as that." delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil,nil];
    [self fadeCaptionsIn];
    [alert show];
    [NSTimer scheduledTimerWithTimeInterval: 3.0 target:self selector:@selector(fadeCaptionsOutTimer:) userInfo:nil repeats: NO];
}



// ======== Text view methods ========
-(BOOL)textViewShouldBeginEditing:(UITextView *)editingTextView{
    [self animateTextView:YES];
    //Clear it if we only have the default prompt showing.
    if(self.textIsEmpty)
       editingTextView.text = @"";
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)editingTextView{
    
    [self animateTextView:NO];
    if([editingTextView.text isEqualToString:@""]) {
        editingTextView.text = taskPrompt;
        self.textIsEmpty = YES;
    } else {
        self.textIsEmpty = NO;
    }
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

- (void)addTaskToArray:(Task *)task
{
    self.tasks = [self.tasks arrayByAddingObject:task];
}


- (void)addTaskComponentsToArray:(NSString *)title dateStarted:(NSDate *)dateStarted completed:(bool)completed
{
    Task *newTask = [[Task alloc] init];
    
    newTask.title = title;
    newTask.dateStarted = dateStarted;
    newTask.completed = completed; 
    
    [self addTaskToArray:newTask];
}

- (void)addTaskComponentsToPlist:(NSString *)title dateStarted:(NSDate *)dateStarted completed:(bool)completed
{
    Task *task = [[Task alloc] init];
    
    task.title = title;
    task.dateStarted = dateStarted;
    task.completed = completed; 
    
    
    //Initialize    
    NSArray *plistArr = [[NSArray alloc] init];
    
    //Plist document path
    NSString *plistPath = [self plistPath];
	
    //Populate array from plist
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        plistArr = [NSArray arrayWithContentsOfFile:plistPath];
	}
    
    if(task != nil){
        NSNumber *completed = [NSNumber numberWithBool:task.completed];
        NSDictionary *taskInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  task.title,@"taskTitle",
                                  task.dateStarted,@"taskDateStarted",
                                  completed,@"taskCompleted", 
                                  nil];
        plistArr = [plistArr arrayByAddingObject:taskInfo];
    }
    
    //Write to plist
    bool successfullySaved = [plistArr writeToFile:plistPath atomically:YES];
    if(!successfullySaved)
        NSLog(@"Save failed");
}

- (void)addCurrentTaskComponentsToArray:(bool)completed
{
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [self addTaskComponentsToArray:self.textTask.text dateStarted:now completed:completed];
    [self addTaskComponentsToPlist:self.textTask.text dateStarted:now completed:completed];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Show Task List"])
    {   
        NSMutableArray * copy = [NSMutableArray arrayWithCapacity:[self.tasks count]];
        
        for(int i = 0; i < [self.tasks count]; i++) {
            [copy addObject:[self.tasks objectAtIndex:[self.tasks count] - i - 1]];
        }
        
        [segue.destinationViewController setTasks:copy]; 
        [segue.destinationViewController setCaller:self];
    }
}

@end
