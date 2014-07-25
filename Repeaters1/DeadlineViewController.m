//
//  DeadlineViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "DeadlineViewController.h"

@interface DeadlineViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UIDatePicker *deadlinePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (NSDate *)setDeadlineDate;
@end

@implementation DeadlineViewController

@synthesize dateFormatter = _dateFormatter;
@synthesize hour = _hour;
@synthesize minute = _minute;
@synthesize deadline = _deadline;
@synthesize deadlinePicker = _deadlinePicker;
@synthesize dateLabel = _dateLabel;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSDate *)setDeadlineDate
{
    NSDate *today = [NSDate date];
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit;
    NSDateComponents *comps = [usersCalendar components:unitFlags fromDate:today];
    [comps setMinute:0];
    [comps setHour:17];
    
    today = [usersCalendar dateFromComponents:comps];
    return today;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //IMPORTANT: set default to 5 pm
    
    self.deadline = [self setDeadlineDate];
    self.deadlinePicker.datePickerMode = UIDatePickerModeTime;
    [self.deadlinePicker addTarget:self action:@selector(revealDeadline:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [self setDeadlinePicker:nil];
    [self setDateLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)revealDeadline:(id)sender
{
    self.deadline = [self.deadlinePicker date];
    self.dateLabel.text = [FormatController formatTimeFromDeadline:self.deadline];
    NSLog(@"Deadline Time set to: %@", self.dateLabel.text);

    /*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    //NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSString *formattedDeadline = [formatter stringFromDate:self.deadline];
    //NSString *selectionString = [[NSString alloc] initWithFormat:@"%@", self.deadline];
    //[self.deadline descriptionWithLocale:usLocale]
    self.dateLabel.text = formattedDeadline;
    //self.deadlineLabel.text = [self.dateFormatter stringFromDate:self.deadlinePicker.date];
    */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return YES;
}

- (IBAction)doneTime:(id)sender
{
    NSLog(@"doneTime: self.deadline = %@", self.deadline);
    [self.delegate deadlineViewController:self didGetDeadline:self.deadline];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

@end
