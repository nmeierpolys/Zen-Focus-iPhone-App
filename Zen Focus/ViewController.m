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
@synthesize textTime = _textTime;
@synthesize imageBackground = _imageBackground;
@synthesize viewControls = _viewControls;
@synthesize restartLabel = _restartLabel;
@synthesize playLabel = _playLabel;
@synthesize titleView = _titleView;
@synthesize textTask = _textTask;
@synthesize tasks = _tasks;
@synthesize MainView = _MainView;

@synthesize textIsEmpty = _textIsEmpty;

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
    self.textTask.text = taskPrompt; 
    self.textIsEmpty = YES;
    
    self.textTime.text = [self timeTextFromInterval:interval];
    self.textTask.layer.cornerRadius = 5;
    self.textTask.layer.borderColor = [UIColor grayColor].CGColor;
    self.textTask.layer.borderWidth = 1.0f;
    
    [self fadeCaptionsIn];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 3.0 target:self selector:@selector(fadeCaptionsOutTimer:) userInfo:nil repeats: NO];
    
    
    self.tasks = [[NSArray alloc] init];
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

- (void)printFramePosition:(CGRect)frame withLabel:(NSString *)label
{
    NSString *output = [NSString stringWithFormat:@"(%.0f,%.0f,%.0f,%.0f)",
                        frame.origin.x, 
                        frame.origin.y-40, 
                        frame.size.width, 
                        frame.size.height-60];
    NSLog(@"%@: %@",label,output);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self printFramePosition:self.textTask.frame withLabel:@"textTask portrait"];
        [self printFramePosition:self.imageBackground.frame withLabel:@"imageBackground portrait"];
        [self printFramePosition:self.titleView.frame withLabel:@"titleView portrait"];
        [self printFramePosition:self.viewControls.frame withLabel:@"viewControls portrait"];
        //Landscape
        self.textTask.frame = CGRectMake(self.textTask.frame.origin.x, 
                                         self.textTask.frame.origin.y-40, 
                                         self.textTask.frame.size.width, 
                                         self.textTask.frame.size.height-60);
        
        self.imageBackground.frame = CGRectMake(self.imageBackground.frame.origin.x-85, 
                                                self.imageBackground.frame.origin.y, 
                                                775, 
                                                315);
        self.titleView.frame = CGRectMake(self.titleView.frame.origin.x, 
                                          self.titleView.frame.origin.y-25, 
                                          self.titleView.frame.size.width, 
                                          self.titleView.frame.size.height);
        self.viewControls.frame = CGRectMake(self.viewControls.frame.origin.x, 
                                             self.viewControls.frame.origin.y+5, 
                                             self.viewControls.frame.size.width, 
                                             self.viewControls.frame.size.height);
    }
    else
    {
        [self printFramePosition:self.textTask.frame withLabel:@"textTask landscape"];
        [self printFramePosition:self.imageBackground.frame withLabel:@"imageBackground landscape"];
        [self printFramePosition:self.titleView.frame withLabel:@"titleView landscape"];
        [self printFramePosition:self.viewControls.frame withLabel:@"viewControls landscape"];
        
        //Portrait
        self.textTask.frame = CGRectMake(self.textTask.frame.origin.x, 
                                         self.textTask.frame.origin.y+40, 
                                         self.textTask.frame.size.width, 
                                         self.textTask.frame.size.height+60);
        
        self.imageBackground.frame = CGRectMake(self.imageBackground.frame.origin.x+85, 
                                                self.imageBackground.frame.origin.y, 
                                                536, 
                                                500);
        self.titleView.frame = CGRectMake(self.titleView.frame.origin.x, 
                                          self.titleView.frame.origin.y+25, 
                                          self.titleView.frame.size.width, 
                                          self.titleView.frame.size.height);
        self.viewControls.frame = CGRectMake(self.viewControls.frame.origin.x, 
                                             self.viewControls.frame.origin.y-5, 
                                             self.viewControls.frame.size.width, 
                                             self.viewControls.frame.size.height);
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
    if(up)
        self.textTask.transform = CGAffineTransformMakeTranslation (0, -40);
    else
        self.textTask.transform = CGAffineTransformMakeTranslation (0, 0);
    
    [UIView commitAnimations];
}

-(void) fadeCaptionsOutTimer: (NSTimer *)theTimer {
    [self fadeCaptionsOut];
}


// ======== Real logic methods ========
- (void) loadDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    double numMinutes = [[defaults stringForKey:@"duration"] doubleValue];
    if(numMinutes == 0)
        numMinutes = 25;
    
    interval = numMinutes * 60;
    remainingTime = interval;
    self.textTime.text = [self timeTextFromInterval:interval];
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
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 3.0 target:self selector:@selector(fadeCaptionsOutTimer:) userInfo:nil repeats: NO];
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

- (void)addCurrentTaskComponentsToArray:(bool)completed
{
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [self addTaskComponentsToArray:self.textTask.text dateStarted:now completed:completed];
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
