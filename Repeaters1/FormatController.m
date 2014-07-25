//
//  FormatController.m
//  Repeaters1
//
//  Created by Ransom Barber on 8/17/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "FormatController.h"

@implementation FormatController

@synthesize formatter = _formatter;

+ (NSString *)formatOrdinal:(NSString *)ordinal
                     andDay:(NSString *)day
                    andTime:(NSString *)time
{
    return [NSString stringWithFormat:@"Every %@ %@ at %@", ordinal, day, time];
}

+ (NSString *)formatOrdinal:(NSString *)ordinal
                     andDay:(NSString *)day
                    andTime:(NSString *)time
                andNotifier:(NSString *)notifier
{
    return [NSString stringWithFormat:@"Repeats every %@ %@ in a month at %@. Notifier: %@", ordinal, day, time, notifier];
}

+ (NSString *)formatOrdinal:(NSString *)ordinal
                     andDay:(NSString *)day
{
    NSString *label = [NSString stringWithFormat:@"Repeats every %@ %@", ordinal, day];
    //label = [label stringByAppendingString:day];
    //label = [label stringByAppendingString:@" in a month"];
    
    NSLog(@"AppRep: Day set to: %@", label);
    
    return label;
}

+ (NSString *)formatAlertWithOrdinal:(NSString *)ordinal
                              andDay:(NSString *)day
{
    NSString *ordinalAlert = [NSString stringWithFormat:@"Every %@ %@ is not possible.", ordinal, day];
    return ordinalAlert;
}

+ (NSString *)formatTimeFromDeadline:(NSDate *)deadline
{
    if (deadline) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *deadlineString = [formatter stringFromDate:deadline];
        NSLog(@"formatTime: deadline = %@", deadlineString);
        
        return deadlineString;
    } else {
        return @"17:00";
    }
}

+ (NSNumber *)formatHourFromDeadline:(NSDate *)deadline
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *formattedDeadline = [formatter stringFromDate:deadline];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    //NSNumber * myNumber = [f numberFromString:@"42"];
    NSNumber *hour = [f numberFromString:formattedDeadline];
    NSLog(@"formatHour: self.hour = %@", hour);
    return hour;
}

+ (NSNumber *)formatMinuteFromDeadline:(NSDate *)deadline
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    NSString *formattedDeadline = [formatter stringFromDate:deadline];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    //NSNumber * myNumber = [f numberFromString:@"42"];
    NSNumber *minute = [f numberFromString:formattedDeadline];
    NSLog(@"formatMinute: self.minute = %@", minute);
    return minute;
}

+ (NSDate *)formatDefaultHour:(NSNumber *)hour
                    andMinute:(NSNumber *)minute
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setHour:[hour integerValue]];
    [comps setMinute:[minute integerValue]];
    
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    //NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [usersCalendar dateFromComponents:comps];
    
    NSLog(@"formatDefaultHour: deadlineSetting will be set to date = %@", date);
    return date;
}

+ (NSString *)formatTimeLabel:(NSString *)time
{
    return [NSString stringWithFormat:@"At %@", time];
}

+ (NSString *)formatNotifierLabel:(NSString *)notifier
{
    return [NSString stringWithFormat:@"Notify me: %@", notifier];
}

@end
