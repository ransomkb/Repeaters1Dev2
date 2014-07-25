//
//  RepeatersViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "RepeatersTableViewController.h"
#import "Repeater.h"
#import "Deadline+Settings.h"
#import "DetailsViewController.h"
#import "AddRepeaterViewController.h"
#import "AboutRepeatersViewController.h"
#import "FormatController.h"
#import "DateBrain.h"

@interface RepeatersTableViewController ()
@property (strong, nonatomic) NSMutableArray *notifierNamesArray;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) DateBrain *dateBrain;
- (NSDictionary *)setCellColor:(Deadline *)deadline;
- (void)handleSwipeLeft:(UIGestureRecognizer *)recognizer;
- (void)handleSwipeRight:(UIGestureRecognizer *)recognizer;
- (void)scheduleNotifications:(Deadline *)deadline;
- (void)createNotifierNamesArray;
@end

@implementation RepeatersTableViewController

@synthesize repeaterDatabase = _repeaterDatabase;
@synthesize dateBrain = _dateBrain;
@synthesize notifierNamesArray = _notifierNamesArray;
@synthesize settingsInfo = _settingsInfo;
@synthesize formatter = _formatter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)createNotifierNamesArray
{
    self.notifierNamesArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (Deadline *deadline in [[self fetchedResultsController] fetchedObjects]) {
        [self.notifierNamesArray addObject:deadline.whichReminder.name];
    }
}

- (void)scheduleNotifications:(Deadline *)deadline
{
    //self.formatter = [[NSDateFormatter alloc] init]; //[self.formatter stringFromDate:date]
    //[self.formatter setDateStyle:NSDateFormatterMediumStyle];
    //[self.formatter setTimeStyle:NSDateFormatterNoStyle];

    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
   
    //NSDate *now = [NSDate date];
    NSDate *notifyDate = [[NSDate alloc] init];
    notifyDate = [self.dateBrain checkNotifier:deadline];
    
    NSLog(@"scheduleNotifications: deadline.next = %@, time = %@", [self.formatter stringFromDate:deadline.next],  [FormatController formatTimeFromDeadline:deadline.next]);
    NSLog(@"scheduleNotifications: NotifyDate = %@, time = %@", [self.formatter stringFromDate:notifyDate], [FormatController formatTimeFromDeadline:notifyDate]);
    
    if (notifyDate) {
        BOOL notifierCheck = [self.dateBrain cancelNotificationWithName:deadline];
        if (!notifierCheck) {
            localNotif.fireDate = notifyDate;
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.alertBody = [NSString stringWithFormat:@"Deadline: %@ at %@", deadline.whichReminder.name, [self.formatter stringFromDate:deadline.next]];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            //localNotif.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
            // Set the action button
            //localNotif.alertAction = @"Deadline";
            
            NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [infoDict setObject:deadline.whichReminder.name forKey:@"deadlineName"];
            [infoDict setObject:deadline.notify forKey:@"notifier"];
            [infoDict setObject:deadline.next forKey:@"next"];
            localNotif.userInfo = infoDict;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            NSLog(@"scheduleNotifications: notification scheduled for %@", [infoDict objectForKey:@"deadlineName"]);
                //[self.tableview reloadData];
        }
    } else return;
}

- (void)setUpFetchedResultsController
{
    // self.fetchedResultsController = ...?
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deadline"];
    // request.predicate - no predicate means get all. need sortDescriptors
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"next" ascending:YES]];
    
    //initializing frc seems to cause a fetch
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.repeaterDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    NSLog(@"setUpFetchedResultsController: now set.");
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [Deadline checkDeadlinesInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [self createNotifierNamesArray];
    NSLog(@"setUpFetchedResultsController: self.notifierNamesArray.count = %d", self.notifierNamesArray.count);
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.repeaterDatabase.fileURL path]]) {
        [self.repeaterDatabase saveToURL:self.repeaterDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setUpFetchedResultsController];
            //IMPORTANT: THIS SHOULD BE CALLED WHEN DONE WITH EDITOR OR ADDREPEATER [self fetchRepeaterDataIntoDocument:self.repeaterDatabase];
        }];
    } else if (self.repeaterDatabase.documentState == UIDocumentStateClosed) {
        [self.repeaterDatabase openWithCompletionHandler:^(BOOL success) {
            [self setUpFetchedResultsController];
        }];
    } else if (self.repeaterDatabase.documentState == UIDocumentStateNormal) {
        [self setUpFetchedResultsController];
    }
}

//set up automatically when variable is created
- (void)setRepeaterDatabase:(UIManagedDocument *)repeaterDatabase
{
    if (_repeaterDatabase != repeaterDatabase) {
        _repeaterDatabase = repeaterDatabase;
        [self useDocument];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    NSLog(@"Reached viewDidLoad");
    self.dateBrain = [[DateBrain alloc] init];
    self.notifierNamesArray = [[NSMutableArray alloc] init];
    self.formatter = [[NSDateFormatter alloc] init]; //[self.formatter stringFromDate:date]
    [self.formatter setDateStyle:NSDateFormatterMediumStyle];
    [self.formatter setTimeStyle:NSDateFormatterNoStyle];
    
    UISwipeGestureRecognizer *gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [gestureLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:gestureLeft];
    
    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [gestureRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:gestureRight];
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    //NSLog(@"viewDidLoad: All notifications have been canceled.");
    //[self createNotifierNamesArray];
    
    [self.dateBrain checkNotifierNames:self.notifierNamesArray];
    NSLog(@"viewDidLoad: self.notifierNamesArray.count = %d", self.notifierNamesArray.count);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self.dateBrain checkNotifierNames:self.notifierNamesArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Reached viewWillAppear.");
    [super viewWillAppear:animated];
    
    if (!self.repeaterDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Repeater Database"];
        self.repeaterDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    [Repeater checkRepeatersInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    [Deadline checkDeadlinesInManagedObjectContext:self.repeaterDatabase.managedObjectContext];
    //[self.dateBrain checkNotifierNames:self.notifierNamesArray];
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    //NSLog(@"viewWillAppear: All notifications have been canceled.");
    [self createNotifierNamesArray];
    NSLog(@"viewWillAppear: self.notifierNamesArray.count = %d", self.notifierNamesArray.count);
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSDictionary *)setCellColor:(Deadline *)deadline
{
    //CGFloat *red;
    //CGFloat *green;
    //CGFloat *blue;
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit ;
    
    NSDateComponents *colorComps = [usersCalendar components:unitFlags fromDate:[NSDate date] toDate:deadline.next options:0];
    NSLog(@"colorComponents are minute = %d, hour = %d, day = %d", [colorComps minute], [colorComps hour], [colorComps day]);
        
    if ([colorComps day] > 0) {
        if ([colorComps day] > 5) {
            [mutDict setObject:[UIColor purpleColor] forKey:@"color"]; //[UIColor colorWithRed:200 green:0 blue:255 alpha:1.0]
            [mutDict setObject:[UIColor whiteColor] forKey:@"text"];
            return mutDict;
            //return [UIColor purpleColor];
        } else if ([colorComps day] > 2) {
            [mutDict setObject:[UIColor blueColor] forKey:@"color"];
            [mutDict setObject:[UIColor whiteColor] forKey:@"text"];
            return mutDict;
            //return [UIColor blueColor];
        } else if ([colorComps day] > 0) {
            [mutDict setObject:[UIColor greenColor] forKey:@"color"];
            [mutDict setObject:[UIColor darkGrayColor] forKey:@"text"];
            return mutDict;
            //return [UIColor greenColor];
        }
    } else if ([colorComps day] < -2) {
        //DateBrain *brain = [[DateBrain alloc] init];
        [self.dateBrain setNextDeadline:deadline];
        [self.tableView reloadData];
        //[mutDict setObject:[UIColor whiteColor] forKey:@"color"];
        //[mutDict setObject:[UIColor blackColor] forKey:@"text"];
        //return mutDict;
        //return [self setCellColor:deadline];
    } else if ([colorComps minute] < 0) { //([colorComps day] < 0) && ([colorComps hour] < 0) && 
        [mutDict setObject:[UIColor blackColor] forKey:@"color"];
        [mutDict setObject:[UIColor whiteColor] forKey:@"text"];
        return mutDict;
        //return [UIColor blackColor];
    } else if ([colorComps day] == 0) {
        if ([colorComps hour] < 3) {
            [mutDict setObject:[UIColor redColor] forKey:@"color"];
            [mutDict setObject:[UIColor whiteColor] forKey:@"text"];
            return mutDict;
            //return [UIColor redColor];
        } else if ([colorComps hour] < 6) {
            [mutDict setObject:[UIColor orangeColor] forKey:@"color"];
            [mutDict setObject:[UIColor whiteColor] forKey:@"text"];
            return mutDict;
            //return [UIColor orangeColor];
        } else if ([colorComps hour] < 24) {
            [mutDict setObject:[UIColor yellowColor] forKey:@"color"];
            [mutDict setObject:[UIColor darkGrayColor] forKey:@"text"];
            return mutDict;
            //return [UIColor yellowColor];
        }
    }
    
    [mutDict setObject:[UIColor whiteColor] forKey:@"color"];
    [mutDict setObject:[UIColor blackColor] forKey:@"text"];
    return mutDict;
    //return [UIColor whiteColor];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Repeater Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (deadline) {
        //cell.textLabel.font = [UIFont systemFontOfSize:30.0];
        cell.textLabel.text = deadline.whichReminder.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]];
        [self scheduleNotifications:deadline];
        //[self.notifierNamesArray addObject:deadline.whichReminder.name];
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (deadline) {
        NSLog(@"willDisplayCell: deadline name = %@", deadline.whichReminder.name);
        NSDictionary *colorDict = [self setCellColor:deadline];
        cell.backgroundColor = [colorDict objectForKey:@"color"];
        cell.textLabel.textColor = [colorDict objectForKey:@"text"];
        cell.detailTextLabel.textColor = [colorDict objectForKey:@"text"];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        NSLog(@"deadline.next = %@, backgroundcolor = %@", [self.formatter stringFromDate:deadline.next], [self setCellColor:deadline]);
    }
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if (deadline) {
            [self.dateBrain setNextDeadline:deadline];
            [self.tableView reloadData];
        }
    }
 }
 */
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return 60;
 }

- (void)handleSwipeLeft:(UIGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    //UITableViewCell *swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
    NSLog(@"Cell was swiped Left.");
    
    //self.dateBrain = [[DateBrain alloc] init];
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
    if (deadline) {
        deadline.last = deadline.next; //resets last to next
        [self.dateBrain cancelNotificationWithName:deadline]; //prepares for new notification to be set; returns unused BOOL
        [self.dateBrain setNextDeadline:deadline]; //creates new next
        while ([deadline.next isEqualToDate:[deadline.next earlierDate:[NSDate date]]]) {
            [self.dateBrain setNextDeadline:deadline]; //creates new next
        }
        //[self.dateBrain setLastDeadline:deadline];
        //[self scheduleNotifications:deadline];
        NSLog(@"Left-Swipe: now deadline.last = %@", deadline.last);
        //[self.dateBrain checkNotifierNames:self.notifierNamesArray];
        [self.tableView reloadData];
    }
}

- (void)handleSwipeRight:(UIGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    NSLog(@"Cell was swiped Right.");
    
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
    if (deadline) {
        [self.dateBrain cancelNotificationWithName:deadline]; //prepares for new notification to be set; returns unused BOOL
        [self.dateBrain setLastDeadline:deadline]; //creates last from next
        if ([deadline.last isEqualToDate:[deadline.last laterDate:[NSDate date]]]) {
            deadline.next = deadline.last; // resets next
            [self.dateBrain setLastDeadline:deadline]; //creates new last from next
        }
        //[self scheduleNotifications:deadline];
        NSLog(@"Right-Swipe: now deadline.next = %@", deadline.next);
        //[self.dateBrain checkNotifierNames:self.notifierNamesArray];
        [self.tableView reloadData];
    }
}

/*
- (IBAction)swipeDismiss:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"Cell was swiped");
    //[self.dateBrain setNextDeadline:self.deadline];
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Deadline *deadline = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if ([segue.identifier hasPrefix:@"Details"]) {
        DetailsViewController *dvc = (DetailsViewController *)segue.destinationViewController;
        dvc.repeaterDatabase = self.repeaterDatabase;
        dvc.deadline = deadline;
        //dvc.delegate = self; use if need a delegate
    } else if ([segue.identifier hasPrefix:@"Add Repeater"]) {
        AddRepeaterViewController *avc = (AddRepeaterViewController *)segue.destinationViewController;
        // will not use a deadline here because creating a new one; avc.deadline = deadline;
        avc.repeaterDatabase = self.repeaterDatabase;
        avc.name = @"Enter a name";
        avc.parent = TRUE;
        //avc.delegate = self; use if need a delegate
    } else if ([segue.identifier hasPrefix:@"About"]) {
        
    }
}

@end
