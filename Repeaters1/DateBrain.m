//
//  DateBrain.m
//  Repeaters1
//
//  Created by Ransom Barber on 8/20/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "DateBrain.h"

@implementation DateBrain

@synthesize formatter = _formatter;

- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        self.formatter = [[NSDateFormatter alloc] init]; //[self.formatter stringFromDate:date]
        [self.formatter setDateStyle:NSDateFormatterMediumStyle];
        [self.formatter setTimeStyle:NSDateFormatterNoStyle];

    }
    return self;
}

// change this to take care of same names, different deadlines
- (BOOL)cancelNotificationWithName:(Deadline *)deadline
{
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"cancelNotificationWithName: notificationArray has a count of %d", [notificationArray count]);
    for (UILocalNotification *notifier in notificationArray)
    {
        NSString *deadlineName = [notifier.userInfo objectForKey:@"deadlineName"];
        NSDate *deadlineNext = [notifier.userInfo objectForKey:@"next"];
        NSLog(@"cancelNotificationWithName: notificationArray userinfo deadlineName = %@", deadlineName);
        
        if ([deadlineName isEqualToString:deadline.whichReminder.name]) {
            if ([deadlineNext isEqualToDate:deadline.next]) {
                NSLog(@"cancelNotificationWithName: Notifier name and time already in notificationArray so will not cancel notifier.");
                return TRUE;
            } else {
                NSLog(@"cancelNotificationWithName: Notifier name already in notificationArray, but time is different so will cancel notifier.");
            
                [[UIApplication sharedApplication] cancelLocalNotification:notifier];
                return FALSE;
            }
        }
    }
    return FALSE;
}

- (NSDate *)checkNotifier:(Deadline *)deadline
{
    NSString *notifier = deadline.notify;
    NSLog(@"Notifier = %@", notifier);
    //@"No Notifier", @"At Deadline", @"5 Minutes Before", @"15 Minutes Before", @"30 Minutes Before", @"One Hour Before"
    if ([notifier isEqualToString:@"No Notifier"]) {
        return nil;
    } else if ([notifier isEqualToString:@"At Deadline"]) {
        return deadline.next;
    } else if ([notifier isEqualToString:@"5 Minutes Before"]) {
        NSDate *fireDate = [deadline.next dateByAddingTimeInterval:-(60*5)];
        return fireDate;
    } else if ([notifier isEqualToString:@"15 Minutes Before"]) {
        NSDate *fireDate = [deadline.next dateByAddingTimeInterval:-(60*15)];
        return fireDate;
    } else if ([notifier isEqualToString:@"30 Minutes Before"]) {
        NSDate *fireDate = [deadline.next dateByAddingTimeInterval:-(60*30)];
        return fireDate;
    } else if ([notifier isEqualToString:@"One Hour Before"]) {
        NSDate *fireDate = [deadline.next dateByAddingTimeInterval:-(60*60)];
        return fireDate;
    }
    return nil;
}

- (void)checkNotifierNames:(NSMutableArray *)nameArray
{
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"checkNotifierNames: nameArray has a count of %d", [nameArray count]);
    NSLog(@"checkNotifierNames: at first, notificationArray has a count of %d", [notificationArray count]);

    if ([nameArray count] == [notificationArray count]) {
        return; // this may be good enough for a quickie verification that there are now extra local notifications
    }
    
    for (UILocalNotification *notifier in notificationArray)
    {
        NSString *deadlineName = [notifier.userInfo objectForKey:@"deadlineName"];
        
        for (NSString *name in nameArray)
        {
            if ([name isEqualToString:deadlineName]) {
                break;
            }
        }
        [[UIApplication sharedApplication] cancelLocalNotification:notifier];
    }
    
    NSLog(@"checkNotifierNames: after checking, notificationArray has a count of %d", [notificationArray count]);
}

+ (NSCharacterSet *)determineOrdinalCharacterSet:(NSString *)ordinal
{
    NSCharacterSet *th = [NSCharacterSet characterSetWithCharactersInString:@"th"];
    NSCharacterSet *st = [NSCharacterSet characterSetWithCharactersInString:@"st"];
    NSCharacterSet *nd = [NSCharacterSet characterSetWithCharactersInString:@"nd"];
    NSCharacterSet *rd = [NSCharacterSet characterSetWithCharactersInString:@"rd"];
    
    if ([ordinal hasSuffix:@"th"]) {
        return th;
    } else if ([ordinal hasSuffix:@"st"]) {
        return st;
    } else if ([ordinal hasSuffix:@"nd"]) {
        return nd;
    } else {
        return rd;
    }
}

+ (NSInteger)trimOrdinal:(NSString *)ordinal
{
    
    if (ordinal.length != 0) {
        NSString *trimmedOrd = [ordinal stringByTrimmingCharactersInSet:[DateBrain determineOrdinalCharacterSet:ordinal]];
        NSInteger ord = [trimmedOrd integerValue];
        return ord;
    } else {
        return 0;
    }
}

+ (NSInteger)determineDayOfWeekInteger:(NSString *)day
{
    if ([day isEqualToString:@"day"]) {
        return 0;
    } else if ([day isEqualToString:@"Sunday"]) {
        return 1;
    } else if ([day isEqualToString:@"Monday"]) {
        return 2;
    } else if ([day isEqualToString:@"Tuesday"]) {
        return 3;
    } else if ([day isEqualToString:@"Wednesday"]) {
        return 4;
    } else if ([day isEqualToString:@"Thursday"]) {
        return 5;
    } else if ([day isEqualToString:@"Friday"]) {
        return 6;
    } else if ([day isEqualToString:@"Saturday"]) {
        return 7;
    } else {
        return 0;
    }
}

- (void)justChecking
{
    NSLog(@"Got to Just Checking in DateBrain");
}

- (void)setNextDeadline:(Deadline *)deadline
{
    NSLog(@"got to setNextDeadline");
    
    //self.formatter = [[NSDateFormatter alloc] init]; //[self.formatter stringFromDate:date]
    //[self.formatter setDateStyle:NSDateFormatterMediumStyle];
    //[self.formatter setTimeStyle:NSDateFormatterNoStyle];

    NSLog(@"setNextDeadline: deadline.next = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
    NSInteger ordInt = [DateBrain trimOrdinal:deadline.ordinal];
    NSInteger day = [DateBrain determineDayOfWeekInteger:deadline.day];
    
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    
    if ((ordInt == 0) && (day != 0)) { //repeats once a week
        NSLog(@"setNextDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setWeekdayOrdinal:1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        NSLog(@"setNextDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.next = checker; //seems to be working
    } else if ((ordInt != 0) && (day == 0)) { //repeats same date every month
        NSLog(@"setNextDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setMonth:1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        NSLog(@"setNextDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.next = checker; //seems to be working
    } else if((ordInt != 0) && (day != 0)) { //repeats same weekday ordinal once a month
        if (ordInt > 0 && ordInt < 5) {
            //maybe we do not want to limit the ordinal of month; make sure handling 5th weekday in a month; of course we cannot have a fifth sunday every month; don't need to change
        }
        
        NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
        
        NSDateComponents *nextComps = [usersCalendar components:unitFlags fromDate:deadline.next];

        //[nextComps setWeekday:day];
        //[nextComps setWeekdayOrdinal:ordInt];
        NSLog(@"ordint is %d, day is %d, so repeats on same weekday once a month", ordInt, day);
        NSLog(@"nextComps weekdayOrdinal = %d and weekday = %d", [nextComps weekdayOrdinal], [nextComps weekday]);
        [nextComps setMonth:[nextComps month]+1];
        if ([nextComps month] >= 13) {
            [nextComps setMonth:1];
            [nextComps setYear:[nextComps year]+1];
        }
        
        deadline.next = [usersCalendar dateFromComponents:nextComps]; //seems to be working
        NSLog(@"setNextDeadline: adjusted ordinal and weekday deadline = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
    } else if ((ordInt == 0) && (day == 0)) { //repeats everyday
        NSLog(@"setNextDeadline: adjusted every day deadline = %@, time = %@", [self.formatter stringFromDate:deadline.next], [FormatController formatTimeFromDeadline:deadline.next]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setDay:1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        NSLog(@"setNextDeadline: adjusted every day deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.next = checker; //seems to be working
    }
}

- (void)setLastDeadline:(Deadline *)deadline
{
    NSLog(@"got to setLastDeadline");
        
    NSLog(@"setLastDeadline: deadline.last = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
    NSInteger ordInt = [DateBrain trimOrdinal:deadline.ordinal];
    NSInteger day = [DateBrain determineDayOfWeekInteger:deadline.day];
    
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    
    if ((ordInt == 0) && (day != 0)) { //repeats once a week
        NSLog(@"setLastDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setWeekdayOrdinal:-1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        NSLog(@"setLastDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.last = checker; //seems to be working
    } else if ((ordInt != 0) && (day == 0)) { //repeats same date every month
        NSLog(@"setLastDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setMonth:-1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        NSLog(@"setLastDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.last = checker; //seems to be working
    } else if((ordInt != 0) && (day != 0)) { //repeats same weekday ordinal once a month
        if (ordInt > 0 && ordInt < 5) {
            //maybe we do not want to limit the ordinal of month; make sure handling 5th weekday in a month; of course we cannot have a fifth sunday every month; don't need to change
        }
        
        NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
        
        NSDateComponents *lastComps = [usersCalendar components:unitFlags fromDate:deadline.next];
        
        //[lastComps setWeekday:day];
        //[lastComps setWeekdayOrdinal:ordInt];
        NSLog(@"ordint is %d, day is %d, so repeats on same weekday once a month", ordInt, day);
        NSLog(@"lastComps weekdayOrdinal = %d and weekday = %d", [lastComps weekdayOrdinal], [lastComps weekday]);
        [lastComps setMonth:[lastComps month]-1];
        if ([lastComps month] >= 13) {
            [lastComps setMonth:1];
            [lastComps setYear:[lastComps year]];
        }
        
        deadline.last = [usersCalendar dateFromComponents:lastComps]; //seems to be working
        NSLog(@"setLastDeadline: adjusted ordinal and weekday deadline = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
    } else if ((ordInt == 0) && (day == 0)) { //repeats everyday
        NSLog(@"setLastDeadline: adjusted every day deadline = %@, time = %@", [self.formatter stringFromDate:deadline.last], [FormatController formatTimeFromDeadline:deadline.last]);
        NSDateComponents *tempComps = [[NSDateComponents alloc] init];
        [tempComps setDay:-1];
        NSDate *checker = [usersCalendar dateByAddingComponents:tempComps toDate:deadline.next  options:0];
        NSLog(@"setLastDeadline: adjusted every day deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
        deadline.last = checker; //seems to be working
    }
}

- (NSDate *)determineFirstDeadline:(NSDictionary *)dict
{
    NSLog(@"determineFirstDeadline: using");
    
    NSInteger ordInt = [DateBrain trimOrdinal:[dict objectForKey:@"ordinal"]];
    NSInteger day = [DateBrain determineDayOfWeekInteger:[dict objectForKey:@"day"]];
    
    NSNumber *minute = [dict objectForKey:@"minute"];
    NSNumber *hour = [dict objectForKey:@"hour"];
    
    NSLog(@"determineFirstDeadline: ordinal = %d, weekday = %d, hour = %@, minute = %@", ordInt, day, hour, minute);
    
    NSDate *today = [NSDate date];
    NSDate *date = [[NSDate alloc] init];
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *nextComps = [[NSDateComponents alloc] init];
    NSDateComponents *todayComps = [usersCalendar components:unitFlags fromDate:today];
    
    [nextComps setMinute:[minute integerValue]];
    NSLog(@"nextComps minute = %d", [nextComps minute]);
    [nextComps setHour:[hour integerValue]];
    NSLog(@"nextComps hour = %d", [nextComps hour]);
    [nextComps setMonth:[todayComps month]];
    NSLog(@"nextComps month = %d", [nextComps month]);
    [nextComps setYear:[todayComps year]];
    NSLog(@"nextComps year = %d", [nextComps year]);
    
    
    //self.formatter = [[NSDateFormatter alloc] init]; //[self.formatter stringFromDate:date]
    //[self.formatter setDateStyle:NSDateFormatterMediumStyle];
    //[self.formatter setTimeStyle:NSDateFormatterNoStyle];

    if ((ordInt == 0) && (day != 0)) {
        [nextComps setWeekday:day];
        [nextComps setWeekdayOrdinal:1];
        NSLog(@"ordint is 0, day is %d, so repeats every week, set to first one", day);
        NSLog(@"nextComps weekdayOrdinal = %d and weekday = %d", [nextComps weekdayOrdinal], [nextComps weekday]);
        
        date = [usersCalendar dateFromComponents:nextComps];
        NSLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        NSLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
        NSDate *checker = [date laterDate:today];
        if ([checker isEqualToDate:today]) {
            NSLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            [nextComps setWeekdayOrdinal:[todayComps weekdayOrdinal]];
            
            date = [usersCalendar dateFromComponents:nextComps];
            NSLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
            NSLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
            NSDate *checker = [date laterDate:today];
            if ([checker isEqualToDate:today]) {
                NSLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
                NSLog(@"nextcomps weekdayOrdinal = %d", [nextComps weekdayOrdinal]);
                NSDateComponents *tempComps = [[NSDateComponents alloc] init];
                [tempComps setWeekdayOrdinal:1];
                checker = [usersCalendar dateByAddingComponents:tempComps toDate:date  options:0];
                NSLog(@"determineFirstDeadline: adjusted weekday deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
                date = checker;
            }
        }
    } else if ((ordInt != 0) && (day == 0)) {
        [nextComps setDay:ordInt];
        NSLog(@"ordint is %d, day is 0, so repeats on the same date every month", ordInt);
        NSLog(@"nextComps day = %d", [nextComps day]);
        
        date = [usersCalendar dateFromComponents:nextComps];
        NSLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        NSLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
        NSDate *checker = [date laterDate:today];
        if ([checker isEqualToDate:today]) {
            NSLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            
            NSDateComponents *tempComps = [[NSDateComponents alloc] init];
            [tempComps setMonth:1];
            checker = [usersCalendar dateByAddingComponents:tempComps toDate:date  options:0];
            NSLog(@"determineFirstDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            date = checker;
        }
    } else if((ordInt != 0) && (day != 0)) {
        if (ordInt > 0 && ordInt < 5) {
            [nextComps setWeekday:day];
            [nextComps setWeekdayOrdinal:ordInt];
            NSLog(@"ordint is %d, day is %d, so repeats on same weekday once a month", ordInt, day);
            NSLog(@"nextComps weekdayOrdinal = %d and weekday = %d", [nextComps weekdayOrdinal], [nextComps weekday]);
        }
        //deal with error
        
        date = [usersCalendar dateFromComponents:nextComps];
        NSLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        NSLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
        NSDate *checker = [date laterDate:today];
        if ([checker isEqualToDate:today]) {
            NSLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            
            [nextComps setMonth:[nextComps month]+1];
            if ([nextComps month] >= 13) {
                [nextComps setMonth:1];
                [nextComps setYear:[nextComps year]+1];
            }
            
            date = [usersCalendar dateFromComponents:nextComps];
            NSLog(@"determineFirstDeadline: adjusted month deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        }
    } else if ((ordInt == 0) && (day == 0)) {
        [nextComps setDay:[todayComps day]];
        NSLog(@"ordint is 0, day is 0, so repeats every day");
        NSLog(@"nextComps day = %d", [nextComps day]);
        
        date = [usersCalendar dateFromComponents:nextComps];
        NSLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
        NSLog(@"determineFirstDeadline: today = %@, time = %@", [self.formatter stringFromDate:today], [FormatController formatTimeFromDeadline:today]);
        NSDate *checker = [date laterDate:today];
        if ([checker isEqualToDate:today]) {
            NSLog(@"determineFirstDeadline: checker = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            NSDateComponents *tempComps = [[NSDateComponents alloc] init];
            [tempComps setDay:1];
            checker = [usersCalendar dateByAddingComponents:tempComps toDate:date  options:0];
            NSLog(@"determineFirstDeadline: adjusted ordinal deadline = %@, time = %@", [self.formatter stringFromDate:checker], [FormatController formatTimeFromDeadline:checker]);
            date = checker;
        }
    }
    
    //NSDate *date = [usersCalendar dateFromComponents:nextComps];
    //NSDate *date = [usersCalendar dateByAddingComponents:nextComps toDate:today  options:0];
   
    
    //NSDateComponents *logComps = [usersCalendar components:unitFlags fromDate:date];
        //NSLog(@"determineFirstDeadline: deadline = %@", [self.formatter stringFromDate:date]);
    
    NSLog(@"determineFirstDeadline: deadline = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
    
    
    //return [NSDate date];
    return date;
}

@end

/*
- (NSDate *)determineDeadline:(Deadline *)deadline
{
    NSDate *today = [NSDate date];
    //trim the ordinal to get an integer
    NSInteger ordInt = [DateBrain trimOrdinal:deadline.ordinal];
    NSInteger day = [DateBrain determineDayOfWeekInteger:deadline.day];
    
    //get last deadline
    NSDate *last = deadline.last;
    //create a calendar and components
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSDateComponents *lastComps = [[NSDateComponents alloc] init];
    NSDateComponents *nextComps = [[NSDateComponents alloc] init];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *todayComps = [usersCalendar components:unitFlags fromDate:today];
    
    if (last) {
        lastComps = [usersCalendar components:unitFlags fromDate:last];
    } else {
        [lastComps setMinute:[deadline.minute integerValue]];
        [lastComps setHour:[deadline.hour integerValue]];
        
        if ((ordInt == 0) && (day != 0)) {
            [lastComps setWeekdayOrdinal:1];
            [lastComps setWeekday:day];
        } else if ((ordInt != 0) && (day == 0)) {
            [lastComps setDay:ordInt];
        } else if((ordInt != 0) && (day != 0)) {
            if (ordInt > 0 && ordInt < 5) {
                [lastComps setWeekdayOrdinal:ordInt];
                [lastComps setWeekday:day];
            }
            //deal with error
        } else if ((ordInt == 0) && (day == 0)) {
            [lastComps setDay:[todayComps day]];
        } else {
            //deal with error
        }
        
        [lastComps setMonth:[todayComps month]];
        [lastComps setYear:[todayComps year]];
    }
    
    [nextComps setMinute:[lastComps minute]];
    [nextComps setHour:[lastComps hour]];
    
    if ((ordInt == 0) && (day != 0)) {
        //[lastComps setWeekdayOrdinal:1];
        //NSDate *date = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
        [nextComps setWeekday:day];
        // check todays ordinal and weekday; if today is not equal to next, set day, and if todays weekday is greater or lower than nexts, set ordinal maybe +1
        if ([todayComps weekday] == day) {
            if ([todayComps hour] > [deadline.hour integerValue]) {
                [nextComps setWeekdayOrdinal:[todayComps weekdayOrdinal]];
            } else {
                if ([todayComps weekdayOrdinal] <= 3) {
                    [nextComps setWeekdayOrdinal:[todayComps weekdayOrdinal]+1];
                } else {
                    [nextComps setWeekdayOrdinal:1];
                }
            }
        } else if ([todayComps weekday] > day) {
            [nextComps setWeekdayOrdinal:[todayComps weekdayOrdinal]];
        } else { //means that next is in future
            if ([todayComps weekdayOrdinal] <= 3) {
                [nextComps setWeekdayOrdinal:[todayComps weekdayOrdinal]+1];
            } else {
                [nextComps setWeekdayOrdinal:1];
            }
        }
    } else if ((ordInt != 0) && (day == 0)) {
        //[lastComps setDay:ordInt];
        [nextComps setDay:[lastComps day]];
        //set the correct month; check todays day; if lower, same month, if higher, +1
        if ([todayComps day] >= ordInt) {
            [nextComps setMonth:[todayComps month]];
            [nextComps setYear:[todayComps year]];
        } else {
            [nextComps setMonth:[todayComps month]+1]; // deal with december
            if([nextComps month] > 12){
                [nextComps setMonth:1];
                [nextComps setYear:[todayComps year]+1];
            }
        }
    } else if((ordInt != 0) && (day != 0)) {
        if (ordInt > 0 && ordInt < 5) {
            //[lastComps setWeekdayOrdinal:ordInt];
            //[lastComps setWeekday:day];
            //set correct month, like above
        }
        //deal with error
    } else if ((ordInt == 0) && (day == 0)) {
        //[lastComps setDay:[todayComps day]];
        //compare time; if now is past, day is todays day +1
        if ([todayComps hour] > [deadline.hour integerValue]) {
            [nextComps setDay:[todayComps day]];
        } else {
            [nextComps setDay:[todayComps day]+1];
            
        }
    } else {
        //deal with error
    }
    
    //need to set the correct month and year
    [nextComps setMonth:[lastComps month]];
    [nextComps setYear:[lastComps year]];
    
    NSDate *date = [usersCalendar dateFromComponents:nextComps];
    return date;
}
*/
/*
- (NSDate *)calculateDeadline:(Deadline *)deadline
{
    NSDate *now = [NSDate date]; // set to greenwhich time; needs adjustment
    NSLog(@"calculateDeadline: now = %@", now); //[self.formatter stringFromDate:now]
    
    //self.formatter = [[NSDateFormatter alloc] init];
    //[self.formatter setDateStyle:NSDateFormatterMediumStyle];
    //[self.formatter setTimeStyle:NSDateFormatterNoStyle];
    //[self.formatter setLocale:]; do not need as locale should default to user preference
    
    //sets the date
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSLog(@"deadline.minute = %d", [deadline.minute integerValue]);
    [comps setMinute:[deadline.minute integerValue]];
    NSLog(@"deadline.hour = %d", [deadline.hour integerValue]);
    [comps setHour:[deadline.hour integerValue]];
    //[comps setDay:20];
    [comps setWeekday:1];
    [comps setWeekdayOrdinal:4];// The first Monday in the month
    [comps setMonth:8];
    [comps setYear:2012];
    
    //used to set beginning cal
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    NSLog(@"calculateDeadline: date = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
    
    //used to set users cal
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *components = [usersCalendar components:unitFlags fromDate:date];
    //NSDateComponents *components = [usersCalendar components:unitFlags fromDate:now]; // was set to fromDate:date; just experimenting, so change back; proved usersCaledar is formatting to now time here
    // create another nsdatecomponents with created deadline date to compare
    NSInteger minute = [components minute];
    NSInteger hour = [components hour];
    NSInteger day = [components day]; // 15 if using hebrew calendar
    NSInteger weekday = [components weekday];
    NSInteger month = [components month]; // 9
    NSInteger year = [components year]; // 5764
    NSLog(@"calculateDeadline: minute = %d, hour = %d, day = %d. weekday = %d, month = %d, year = %d", minute, hour, day, weekday, month, year);
    
    NSDate *next = [usersCalendar dateFromComponents:components];
    NSLog(@"calculateDeadline: next = %@, time = %@", [self.formatter stringFromDate:date], [FormatController formatTimeFromDeadline:date]);
    
    //gets the day
    NSDateComponents *weekdayComponents = [usersCalendar components:NSWeekdayCalendarUnit fromDate:next];
    NSInteger dayOfWeek = [weekdayComponents weekday];
    NSLog(@"calculateDeadline: dayOfWeek = %d", dayOfWeek);
    
    //IMPORTANT: NEED TO FINISH THIS
    return next;
}
*/
//make a method to see if past deadline and less than 2 days
/*
 //make a method to check the time if today is a deadline
 + (NSInteger *)formatCalendarDayFromOrdinal:(NSString *)ordinal andDay:(NSString *)day
 {
 NSDate *now = [NSDate date];
 
 if ([day isEqualToString:@"day"]) {
 }
 }
 */
/*
- (NSDictionary *)dictionaryFromCurrentTime
{
    NSDate *now = [NSDate date];
    NSCalendar *usersCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *components = [usersCalendar components:unitFlags fromDate:now];
    //NSNumber *minute = [NSNumber numberWithInt:[components minute]];
    //NSNumber *hour = [ns]
    NSMutableDictionary *nowDict = [[NSMutableDictionary alloc] initWithCapacity:6];
    [nowDict setObject:[NSNumber numberWithInt:[components minute]] forKey:@"minute"];
    return nowDict;
}
*/

/*
 NSDateComponents *comps = [[NSDateComponents alloc] init];
 [comps setDay:6];
 [comps setMonth:5];
 [comps setYear:2004];
 NSCalendar *gregorian = [[NSCalendar alloc]
 initWithCalendarIdentifier:NSGregorianCalendar];
 NSDate *date = [gregorian dateFromComponents:comps];
 [comps release];
 NSDateComponents *weekdayComponents =
 [gregorian components:NSWeekdayCalendarUnit fromDate:date];
 int weekday = [weekdayComponents weekday];
 
 Another Example:
 NSDateComponents *components = [[NSDateComponents alloc] init];
 [components setDay:6];
 [components setMonth:5];
 [components setYear:2004];
 
 NSInteger weekday = [components weekday]; // Undefined (== NSUndefinedDateComponent)
 
 For checking if today is a deadline day:
 
 NSDate *today = [NSDate date];
 NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
 NSInteger day = [weekdayComponents day];
 NSInteger weekday = [weekdayComponents weekday];
 This gives you the absolute components for a date. For example, if you ask for the year and day components for November 7, 2010, you get 2010 for the year and 7 for the day. If you instead want to know what number day of the year it is you can use the ordinalityOfUnit:inUnit:forDate: method of the NSCalendar class.
 
 To convert components of a date from one calendar to another—for example, from the Gregorian calendar to the Hebrew calendar—you first create a date object from the components using the first calendar, then you decompose the date into components using the second calendar. Listing 8 shows how to convert date components from one calendar to another.
 NSDateComponents *comps = [[NSDateComponents alloc] init];
 [comps setDay:6];
 [comps setMonth:5];
 [comps setYear:2004];
 
 NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 NSDate *date = [gregorian dateFromComponents:comps];
 
 NSCalendar *hebrew = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
 NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
 
 NSDateComponents *components = [hebrew components:unitFlags fromDate:date];
 
 NSInteger day = [components day]; // 15
 NSInteger month = [components month]; // 9
 NSInteger year = [components year]; // 5764
 
 The following example shows how to add 2 months and 3 days to the current date and time using an existing calendar (gregorian):
 
 NSDate *currentDate = [NSDate date];
 NSDateComponents *comps = [[NSDateComponents alloc] init];
 [comps setMonth:2];
 [comps setDay:3];
 
 NSDate *date = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
 
 
 Returns, as an NSDateComponents object using specified components, the difference between two supplied dates.
 
 - (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate options:(NSUInteger)opts
 
 Returns the identifier for the receiver. Which calendar is being used
 
 - (NSString *)calendarIdentifier
 
 
 for localization
 NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
 
 ex: NSDateFormatterShortStyle
 Specifies a short style, typically numeric only, such as “11/23/37” or “3:30pm”.
 
 [dateFormatter setDateStyle:NSDateFormatterMediumStyle]; Specifies a medium style, typically with abbreviated text, such as “Nov 23, 1937”.
 [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
 [dateFormatter setLocale:usLocale]; Better: autoupdatingCurrentLocale
 
 NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:118800]; don't know what this is for; probably for using a date that is not now, or not derived from calendar,etc.
 
 NSString *formattedDateString = [dateFormatter stringFromDate:date];
 
 NSLog(@"formattedDateString for locale %@: %@", [[dateFormatter locale] localeIdentifier], formattedDateString);
 
 Difference between two dates
 Returns, as an NSDateComponents object using specified components, the difference between two supplied dates.
 
 - (NSDateComponents *)components:(NSUInteger)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate options:(NSUInteger)opts
 ex: NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
 
 TimeIntervals:
 
 Returns a new NSDate object that is set to a given number of seconds relative to the receiver.
 - (id)dateByAddingTimeInterval:(NSTimeInterval)seconds
 
 Returns The interval between the receiver and the current date and time. If the receiver is earlier than the current date and time, the return value is negative.
 - (NSTimeInterval)timeIntervalSinceNow
 
 Returns the interval between the receiver and another given date.
 - (NSTimeInterval)timeIntervalSinceDate:(NSDate *)anotherDate
 
 Creates and returns an NSDate object set to a given number of seconds from the current date and time.
 + (id)dateWithTimeIntervalSinceNow:(NSTimeInterval)seconds
 
 Creates and returns an NSDate object set to a given number of seconds from the first instant of 1 January 2001, GMT.
 + (id)dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)seconds
 
 Creates and returns an NSDate object set to a given number of seconds from the specified date.
 + (id)dateWithTimeInterval:(NSTimeInterval)seconds sinceDate:(NSDate *)date
 
 Also, use earlierDate or laterDate to see which of two dates is earlier/later
 
 separate stuff:
 NSNumber to NSInteger
 
 NSInteger myInteger = [myNumber integerValue];
 
 String Stuff:
 create character sets for ordinals, th, st, rd, nd; use to trim ordinals; convert to nsnumber or nsinteger
 
 Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
 
 - (NSString *)stringByTrimmingCharactersInSet:(NSCharacterSet *)set
 
 Returns a character set containing the characters in a given string.
 
 + (id)characterSetWithCharactersInString:(NSString *)aString
 
 */
