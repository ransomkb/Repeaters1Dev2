//
//  DateBrain.h
//  Repeaters1
//
//  Created by Ransom Barber on 8/20/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deadline.h"
#import "Repeater.h"
#import "Deadline.h"
#import "FormatController.h"

@interface DateBrain : NSObject

@property (strong, nonatomic) NSDateFormatter *formatter;

+ (NSCharacterSet *)determineOrdinalCharacterSet:(NSString *)ordinal;
+ (NSInteger)trimOrdinal:(NSString *)ordinal;
+ (NSInteger)determineDayOfWeekInteger:(NSString *)day;

- (BOOL)cancelNotificationWithName:(Deadline *)deadline;

- (NSDate *)determineFirstDeadline:(NSDictionary *)dict;
- (NSDate *)checkNotifier:(Deadline *)deadline;

- (void)justChecking;
- (void)setNextDeadline:(Deadline *)deadline;
- (void)setLastDeadline:(Deadline *)deadline;
- (void)checkNotifierNames:(NSMutableArray *)nameArray;

@end
