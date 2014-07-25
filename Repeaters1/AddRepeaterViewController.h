//
//  AddRepeaterViewController.h
//  Repeaters1
//
//  Created by Ransom Barber on 8/2/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayViewController.h"
#import "DeadlineViewController.h"
#import "NotifyTableViewController.h"
#import "Deadline+Settings.h"
#import "Repeater+Settings.h"
#import "FormatController.h"
#import "DateBrain.h"

@interface AddRepeaterViewController : UIViewController <UITextFieldDelegate, DayViewControllerDelegate, DeadlineViewControllerDelegate, NotifyTableViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIManagedDocument *repeaterDatabase;
@property (strong, nonatomic) Deadline *deadline;
@property (strong, nonatomic) DateBrain *dateBrain;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadLabel;
@property (weak, nonatomic) IBOutlet UILabel *notifyLabel;

@property (nonatomic, assign, getter=isParent) BOOL parent;

@property (strong, nonatomic) NSDictionary *settingsInfo;
//@property (strong, nonatomic) NSDictionary *dateDetails;
@property (strong, nonatomic) NSDate *deadlineSetting;
@property (strong, nonatomic) NSNumber *hour;
@property (strong, nonatomic) NSNumber *minute;
@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *ordinalSetting;
@property (strong, nonatomic) NSString *daySetting;
@property (strong, nonatomic) NSString *notifierSetting;
@property (strong, nonatomic) NSString *ordinalAndDay;
@property (strong, nonatomic) NSString *name;

- (IBAction)doneEditor:(id)sender;- (NSDictionary *)dateDetails;
- (NSDate *)calculateNextDeadline;
- (NSDate *)lastDeadline;
- (NSDictionary *)updateSettingsInfo;

- (void)raiseLengthAlert;
- (void)defaultSettings;

@end
