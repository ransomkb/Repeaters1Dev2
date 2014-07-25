//
//  AddRepeaterViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 8/2/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

//IMPORTANT: FIX DAYVIEWCONTROLLER SO SETS TO DEFAULT IF USER CHANGES THEIR MIND AND DOESN'T SET ANYTHING; SET EDITOR SO DAY TIME AND NOTIFIER ARE SET TO USERS ORIGINAL CHOICES

#import "AddRepeaterViewController.h"

@interface AddRepeaterViewController ()
//@property (strong, nonatomic) DateBrain *dateBrain;
@end

@implementation AddRepeaterViewController

@synthesize parent;
@synthesize repeaterDatabase = _repeaterDatabase;
@synthesize deadline = _deadline;
@synthesize name = _name;
@synthesize nameTextField = _nameTextField;
@synthesize settingsLabel = _settingsLabel;
@synthesize deadLabel = _deadLabel;
@synthesize notifyLabel = _notifyLabel;
@synthesize settingsInfo = _settingsInfo;
@synthesize ordinalSetting = _ordinalSetting;
@synthesize daySetting = _daySetting;
@synthesize timeString = _timeString;
@synthesize deadlineSetting = _deadlineSetting;
@synthesize notifierSetting = _notifierSetting;
@synthesize ordinalAndDay = _ordinalAndDay;
@synthesize hour = _hour;
@synthesize minute = _minute;
@synthesize dateBrain = _dateBrain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSDictionary *)dateDetails
{
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    [mutDict setObject:self.ordinalSetting forKey:@"ordinal"];
    [mutDict setObject:self.daySetting forKey:@"day"];
    //[mutDict setObject:self.timeString forKey:@"time"];
    [mutDict setObject:self.hour forKey:@"hour"];
    [mutDict setObject:self.minute forKey:@"minute"];
    //[mutDict setObject:self.notifierSetting forKey:@"notify"];
    //[mutDict setObject:[self calculateNextDeadline] forKey:@"next"];
    //[mutDict setObject:[self lastDeadline] forKey:@"last"];
    //[mutDict setObject:self.name forKey:@"name"];
    
    return mutDict;
}

- (NSDate *)calculateNextDeadline
{
    self.dateBrain = [[DateBrain alloc] init];
    [self.dateBrain justChecking];
    NSDate *dead = [self.dateBrain determineFirstDeadline:[self dateDetails]];
    NSLog(@"calculateNextDeadline: datebrain date = %@", dead);
    return dead;
}

- (NSDate *)lastDeadline
{
    if (self.deadline.last) {
        return self.deadline.last;
    } else {
        return [NSDate date];
    }
}

- (NSDictionary *)updateSettingsInfo
{
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    [mutDict setObject:self.ordinalSetting forKey:@"ordinal"];
    [mutDict setObject:self.daySetting forKey:@"day"];
    [mutDict setObject:self.timeString forKey:@"time"];
    [mutDict setObject:self.hour forKey:@"hour"];
    [mutDict setObject:self.minute forKey:@"minute"];
    [mutDict setObject:self.notifierSetting forKey:@"notify"];
    [mutDict setObject:[self calculateNextDeadline] forKey:@"next"];
    [mutDict setObject:[self lastDeadline] forKey:@"last"];
    [mutDict setObject:self.name forKey:@"name"];
    
    return mutDict;
}

- (void)raiseLengthAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More Than 30 Characters"
                                                    message:@"Please Shorten Name"
                                                   delegate:self
                                          cancelButtonTitle:@"Try Again"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text length]) {
        // for returning to Details; no good here [[self presentingViewController] dismissModalViewControllerAnimated:YES];
        // for resigning keyboard, see below
        [textField resignFirstResponder];
    } else if ([textField.text length] > 30) {
        [self raiseLengthAlert];
    }else {
        self.name = textField.text;
        //IMPORTANT: check whether this name is already in Repeaters database
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
    // the below is no good if wish to quit editing without setting repeater
    /*
     if ([textField.text length]) {
     [textField resignFirstResponder];
     return YES;
     } else {
     return NO;
     }
     */
}

- (void)dayViewController:(DayViewController *)sender
                didGetDay:(NSString*)daySetting
{
    //add daySetting to settingsInfo dictionary
    [self dismissModalViewControllerAnimated:YES];
}

- (void)defaultSettings
{
    self.ordinalAndDay = @"Repeats every day in a month";
    self.daySetting = @"day";
    self.ordinalSetting = @"";
    self.timeString = @"17:00";
    self.hour = [[NSNumber alloc] initWithInt:17];
    self.minute = [[NSNumber alloc] initWithInt:00];
    self.deadlineSetting = [FormatController formatDefaultHour:self.hour andMinute:self.minute];
    self.notifierSetting = @"No Notifier";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad: self = %@", self);
    self.nameTextField.delegate = self;
    
    [self defaultSettings];
    // prepare for segue does not set outlets and stuff
    //[self formatSettings];
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setSettingsLabel:nil];
    [self setDeadLabel:nil];
    [self setNotifyLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.nameTextField becomeFirstResponder];
    
    self.settingsLabel.text = @"Default: Repeats every day";
    self.deadLabel.text = @"Default: 17:00";
    self.notifyLabel.text = @"Default: No Notifier";
    self.nameTextField.placeholder = self.name; //@"Enter a name";
    // not using below as want to say default:
    //self.settingsLabel.text = self.ordinalAndDay;
    //self.deadLabel.text = [FormatController formatTimeLabel:self.timeString];
    //self.notifyLabel.text = [FormatController formatNotifierLabel:self.notifierSetting];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
// maybe don't need
- (void)formatSettings
{
    NSString *label = [NSString stringWithFormat:@"Repeats every %@ ", self.ordinalSetting];
    label = [label stringByAppendingString:self.daySetting];
    //label = [label stringByAppendingString:@" in a month"];
    
    NSLog(@"AppRep: Day set to: %@", label);
    
    self.ordinalAndDay = label;
}

- (NSDate *)formatDefaultTime
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setHour:[self.hour integerValue]];
    [comps setMinute:[self.minute integerValue]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    
    NSLog(@"formatDefaultTime: deadlineSetting will be set to date = %@", date);
    return date;
}

- (NSString *)formatTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    
    NSLog(@"formatTime: deadline = %@", [formatter stringFromDate:self.deadlineSetting]);
    
    return [formatter stringFromDate:self.deadlineSetting];
}

- (void)formatHour
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh"];
    NSString *formattedDeadline = [formatter stringFromDate:self.deadlineSetting];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    //NSNumber * myNumber = [f numberFromString:@"42"];
    self.hour = [f numberFromString:formattedDeadline];
    
    NSLog(@"formatHour: self.hour = %@", self.hour);
}

- (void)formatMinute
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    NSString *formattedDeadline = [formatter stringFromDate:self.deadlineSetting];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    //NSNumber * myNumber = [f numberFromString:@"42"];
    self.minute = [f numberFromString:formattedDeadline];
    
    NSLog(@"formatMinute: self.minute = %@", self.minute);
}
*/

- (void)dayViewController:(DayViewController *)sender
            didGetOrdinal:(NSString *)ordinal
             andDidGetDay:(NSString *)dayOfWeek
{
    self.ordinalSetting = ordinal;
    self.daySetting = dayOfWeek;
    NSLog(@"doneDay: self.ordinal = %@ and self.dayOfWeek = %@", ordinal, dayOfWeek);
    self.ordinalAndDay = [FormatController formatOrdinal:self.ordinalSetting andDay:self.daySetting];
    self.settingsLabel.text = self.ordinalAndDay; // maybe can get rid of ordinalAndDay

    //[self formatSettings];
}

- (void)deadlineViewController:(DeadlineViewController *)sender
                didGetDeadline:(NSDate *)deadline
{
    NSLog(@"AppRep: doneTime: self.deadline = %@", deadline);
    self.deadlineSetting = deadline;
    //[self formatSettings];
    self.timeString = [FormatController formatTimeFromDeadline:self.deadlineSetting];
    self.hour = [FormatController formatHourFromDeadline:self.deadlineSetting];
    self.minute = [FormatController formatMinuteFromDeadline:self.deadlineSetting];
    self.deadLabel.text = [FormatController formatTimeLabel:self.timeString];
}

- (void)NotifyTableViewController:(NotifyTableViewController *)sender
                   didGetNotifier:(NSString *)notifier
{
    NSLog(@"AppRep: doneNotifier: self.notifier = %@", notifier);
    self.notifierSetting = notifier;
    //[self formatSettings];
    self.notifyLabel.text = [FormatController formatNotifierLabel:self.notifierSetting];
}

- (IBAction)cancelAddRepeater:(id)sender
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneEditor:(id)sender
{
    NSLog(@"AddRepeater doneEditor reached");
    self.settingsInfo = [self updateSettingsInfo];
    NSLog(@"AddRep doneEditor: settingsInfo = %@", self.settingsInfo);
    NSString *name = [self.settingsInfo objectForKey:@"name"];
   
    if (name.length > 30) {
        [self raiseLengthAlert];
    } else {
        [Deadline deadlineWithSettingsInfo:self.settingsInfo inManagedObjectContext:self.repeaterDatabase.managedObjectContext];
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Add Day"]) {
        DayViewController *dayvc = (DayViewController *)segue.destinationViewController;
        dayvc.delegate = self;
        dayvc.ordinal = @"";
        dayvc.dayOfWeek = @"day";
    } else if ([segue.identifier hasPrefix:@"Add Deadline"]) {
        DeadlineViewController *deadvc = (DeadlineViewController *)segue.destinationViewController;
        deadvc.delegate = self;
    } else if ([segue.identifier hasPrefix:@"Add Notifier"]) {
        NotifyTableViewController *notvc = (NotifyTableViewController *)segue.destinationViewController;
        notvc.delegate = self;
    }
}
@end
