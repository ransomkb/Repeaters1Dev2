//
//  RepeatersViewController.m
//  Repeaters1
//
//  Created by Barber Ransom on 7/23/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "DetailsViewController.h"
#import "EditorViewController.h"
#import "Deadline+Settings.h"
#import "Repeater+Settings.h"
#import "FormatController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;
@property (weak, nonatomic) NSString *name;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) DateBrain *dateBrain;
@end

@implementation DetailsViewController

@synthesize repeaterDatabase = _repeaterDatabase;
@synthesize deadline = _deadline;
@synthesize nameLabel = _nameLabel;
@synthesize dayLabel = _dayLabel;
@synthesize nextLabel = _nextLabel;
@synthesize formatter = _formatter;
@synthesize dateBrain = _dateBrain;
@synthesize name = _name;

/*
- (NSString *)formatDay:(Deadline *)deadline
{
    NSString *label = [NSString stringWithFormat:@"Repeats every %@ ", deadline.ordinal];
    if (deadline.day) {
        label = [label stringByAppendingString:deadline.day];
    }
    label = [label stringByAppendingString:@" in a month"];
    if (deadline.time) {
        label = [label stringByAppendingString:[NSString stringWithFormat:@" at %@.", deadline.time]];
    }
    
    return label;
}
*/

//not working right
-(void)setFormatter:(NSDateFormatter *)formatter
{
    _formatter = formatter;
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init]; //[self.formatter stringFromDate:date]
    }
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.name = self.deadline.whichReminder.name;
    //self.nameLabel.text = self.name;
    //self.dayLabel.text = [FormatController formatDay:[FormatController formatOrdinal:self.deadline.ordinal andDay:self.deadline.day] andTime:[NSString stringWithFormat:@"%@:%@", self.deadline.hour, self.deadline.minute] andNotifier:self.deadline.notify];
    //self.nextLabel.text = @"Need to set Next Deadline";
    //[Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    //[Repeater removeLastRepeater:@"feed frog" inManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    //[Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setDayLabel:nil];
    [self setNextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//IMPORTANT: ADD INFO ABOUT NOTIFIER AND TIME
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.name = self.deadline.whichReminder.name;
    self.nameLabel.text = self.name;
    self.dayLabel.text = [FormatController formatOrdinal:self.deadline.ordinal andDay:self.deadline.day andTime:self.deadline.time andNotifier:self.deadline.notify];
    self.dateBrain = [[DateBrain alloc] init];
    self.formatter = [[NSDateFormatter alloc] init]; //[self.formatter stringFromDate:date]
    [self.formatter setDateStyle:NSDateFormatterMediumStyle];
    [self.formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *nextString = @"Present Deadline: ";
    self.nextLabel.text = [nextString stringByAppendingString:[self.formatter stringFromDate:self.deadline.next]];
    
    NSLog(@"Details: Details viewWillAppear trimmed Ordinal = %d", [DateBrain trimOrdinal:self.deadline.ordinal]);
    /*
    self.nameLabel.text = self.deadline.whichReminder.name;
    self.dayLabel.text = [self formatDay:self.deadline];
    self.nextLabel.text = @"Need to set Next Deadline";
    */
    
    //FormatController *fc = [[FormatController alloc] init];
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    //[fc calculateDeadline:self.deadline];
}
- (IBAction)dismissRepeater:(id)sender
{
    [self.dateBrain cancelNotificationWithName:self.deadline]; //prepares for new notification to be set
    [self.dateBrain setNextDeadline:self.deadline];
    while ([self.deadline.next isEqualToDate:[self.deadline.next earlierDate:[NSDate date]]]) {
        [self.dateBrain setNextDeadline:self.deadline]; //creates new next
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteRepeater
{
    [self.dateBrain cancelNotificationWithName:self.deadline];
    //set up a way to delete the deadline from the database, and the repeater too if it is the last one
    [Deadline removeDeadline:self.deadline inManagedObjectContext:self.deadline.managedObjectContext];
    [Repeater removeLastRepeater:self.name inManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showActionSheet:(id)sender
{
    UIActionSheet *deleteQuery = [[UIActionSheet alloc] initWithTitle:@"Delete" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
    deleteQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [deleteQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deleteRepeater];
        NSLog(@"Delete Button was pushed.");
    } else {
        NSLog(@"Cancel Button was pushed.");
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"Editor Modal"]) {
        EditorViewController *evc = (EditorViewController *)segue.destinationViewController;
        evc.deadline = self.deadline;
        //evc.parent = FALSE;
        //evc.name = self.name;
        //dvc.delegate = self; maybe used but probably not.
    }
}

@end
