//
//  DayViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "DayViewController.h"
#import "DateBrain.h"

@interface DayViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *dayPicker;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (strong, nonatomic) NSArray *ordinalArray;
@property (strong, nonatomic) NSArray *dayArray;
//@property (strong, nonatomic) DateBrain *brain;

@end

//finish this; use info from Reminders; video 15 from one hour in. Setting Delegate methods

@implementation DayViewController

@synthesize dayLabel = _dayLabel;
@synthesize dayPicker = _dayPicker;
@synthesize daySetting = _daySetting;
@synthesize delegate = _delegate;

@synthesize ordinal = _ordinal;
@synthesize dayOfWeek = _dayOfWeek;
@synthesize ordinalArray = _ordinalArray;
@synthesize dayArray = _dayArray;
//@synthesize brain = _brain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.ordinalArray = [NSArray arrayWithArray:[self setOrdinal]];
    self.dayArray = [[NSArray alloc] initWithObjects:@"day", @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil]; //took the empty @"", out
    
    //self.ordinal = @"";
    //self.dayOfWeek = @"day";
    self.dayLabel.text = [FormatController formatOrdinal:self.ordinal andDay:self.dayOfWeek];
}

- (void)viewDidUnload
{
    [self setDayPicker:nil];
    [self setDayLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [self.ordinalArray count];
    }
    
    return [self.dayArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.ordinalArray objectAtIndex:row];
    }
    
    return [self.dayArray objectAtIndex:row];
}

#pragma mark - PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSString *resultString = [[NSString alloc] initWithFormat:@"%@", [self.ordinalArray objectAtIndex:row]];
        
        NSLog(@"resultStringOrd = %@", resultString);
        
        if (!resultString)
        {
            self.ordinal = @"";
        }
        else
        {
            self.ordinal = resultString;
        }
        
        NSLog(@"ordinal = %@", self.ordinal);
    }
    else
    {
        NSString *resultString = [[NSString alloc] initWithFormat:@"%@", [self.dayArray objectAtIndex:row]];
        
        NSLog(@"resultStringDay = %@", resultString);
        
        //self.dayOfWeek = resultString;
        if (!resultString)
        {
            self.dayOfWeek = @"";
        }
        else
        {
            self.dayOfWeek = resultString;
        }
        
        NSLog(@"dayOfWeek = %@", self.dayOfWeek);
    }
    
    NSString *label = [FormatController formatOrdinal:self.ordinal andDay:self.dayOfWeek];
    //[NSString stringWithFormat:@"Repeats every %@ ", self.ordinal];
    //label = [label stringByAppendingString:self.dayOfWeek];
    //label = [label stringByAppendingString:@" in a month"];
    
    NSLog(@"Day set to: %@", label);
    
    self.dayLabel.text = label;
}

- (NSMutableArray *)setOrdinal
{
    NSInteger capacity = 32;
    NSMutableArray *mutableOrdinal = [NSMutableArray arrayWithCapacity:capacity];
    
    for (int i = 0; i<32; i++)
    {
        if (i == 0)
        {
            NSString *none = @"";
            [mutableOrdinal addObject:none];
        }
        else if(i == 1 || i == 21 || i == 31)
        {
            NSString *st = [NSString stringWithFormat:@"%dst", i];
            [mutableOrdinal addObject:st];
        }
        else if(i == 2 || i == 22)
        {
            NSString *nd = [NSString stringWithFormat:@"%dnd", i];
            [mutableOrdinal addObject:nd];
        }
        else if(i == 3 || i == 23)
        {
            NSString *rd = [NSString stringWithFormat:@"%drd", i];
            [mutableOrdinal addObject:rd];
        }
        else
        {
            NSString *th = [NSString stringWithFormat:@"%dth", i];
            [mutableOrdinal addObject:th];
        }
    }
    
    return mutableOrdinal;
}
- (IBAction)doneDay:(id)sender
{
    NSLog(@"doneDay: self.ordinal = %@ and self.dayOfWeek = %@", self.ordinal, self.dayOfWeek);
    NSLog(@"integer of ordinal is %d", [DateBrain trimOrdinal:self.ordinal]);
    
    if ((![self.dayOfWeek isEqualToString:@"day"]) && ([DateBrain trimOrdinal:self.ordinal] > 4)) { //
        UIAlertView *ordinalAlert = [[UIAlertView alloc] init];
        ordinalAlert.delegate = self;
        ordinalAlert.alertViewStyle = UIAlertViewStyleDefault;
        ordinalAlert.message = [FormatController formatAlertWithOrdinal:self.ordinal andDay:self.dayOfWeek];
        [ordinalAlert addButtonWithTitle:@"Try Again"];
        [ordinalAlert show];
    } else {
        [self.delegate dayViewController:self didGetOrdinal:self.ordinal andDidGetDay:self.dayOfWeek];
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
}


@end
