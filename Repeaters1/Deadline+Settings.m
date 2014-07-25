//
//  Deadline+Settings.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "Deadline+Settings.h"
#import "Repeater+Settings.h"

@implementation Deadline (Settings)

+ (Deadline *)deadlineWithSettingsInfo:(NSDictionary *)settingsInfo
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"Deadline+Settings deadlineWithSettingsInfo: settingsInfo = %@", settingsInfo);
    if (!context) {
        NSLog(@"context is nil");
    }
    Deadline *deadline = nil;
    
    // probably should add some way to see if this new deadline matches any already inserted by doing a predicate based on day and whichReminder
    // the code below is suitable for Hegarty's flickrfetcher, so change for your needs (video 14, min. 52)
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deadline"];
    // predicate below is good to fetch one Repeater
    request.predicate = [NSPredicate predicateWithFormat:@"whichReminder = %@ AND day = %@", [settingsInfo objectForKey:@"name"], [settingsInfo objectForKey:@"day"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    /*
    if (!matches) {
         NSLog(@"matches = M %@", matches);
        
        deadline = [NSEntityDescription insertNewObjectForEntityForName:@"Deadline" inManagedObjectContext:context];
        
        deadline.day = [settingsInfo objectForKey:@"day"];
        NSLog(@"deadline.day = %@ after newobject", deadline.day);
        deadline.time = [settingsInfo objectForKey:@"time"];
        deadline.hour = [settingsInfo objectForKey:@"hour"];
        deadline.minute = [settingsInfo objectForKey:@"minute"];
        deadline.next = [settingsInfo objectForKey:@"next"];
        deadline.last = [settingsInfo objectForKey:@"last"];
        deadline.notify = [settingsInfo objectForKey:@"notify"];
        deadline.ordinal = [settingsInfo objectForKey:@"ordinal"];
        deadline.whichReminder = [Repeater repeaterWithName:[settingsInfo objectForKey:@"name"] inManagedObjectContext:context];// set this in repeater - done

    } else
        */
        
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"matches count = 1 %d", [matches count]);
    } else if ([matches count] == 0) {
        NSLog(@"matches count = 2 %d", [matches count]);
        NSLog(@"deadline.day = %@ before newobject", deadline.day);

        deadline = [NSEntityDescription insertNewObjectForEntityForName:@"Deadline" inManagedObjectContext:context];
        
        deadline.day = [settingsInfo objectForKey:@"day"];
        NSLog(@"deadline.day = %@ after newobject", deadline.day);
        deadline.time = [settingsInfo objectForKey:@"time"];
        deadline.hour = [settingsInfo objectForKey:@"hour"];
        deadline.minute = [settingsInfo objectForKey:@"minute"];
        deadline.next = [settingsInfo objectForKey:@"next"];
        deadline.last = [settingsInfo objectForKey:@"last"];
        deadline.notify = [settingsInfo objectForKey:@"notify"];
        deadline.ordinal = [settingsInfo objectForKey:@"ordinal"];
        deadline.whichReminder = [Repeater repeaterWithName:[settingsInfo objectForKey:@"name"] inManagedObjectContext:context];// set this in repeater - done
    } else {
        NSLog(@"matches count = 3 %d", [matches count]);
        deadline = [matches lastObject];
    }
    
    /*
    deadline = [NSEntityDescription insertNewObjectForEntityForName:@"Deadline" inManagedObjectContext:context];
    deadline.day = [settingsInfo objectForKey:@""];
    deadline.time = [settingsInfo objectForKey:@""];
    deadline.next = [settingsInfo objectForKey:@""];
    deadline.last = [settingsInfo objectForKey:@""];
    deadline.notify = [settingsInfo objectForKey:@""];
    deadline.ordinal = [settingsInfo objectForKey:@""];
    deadline.whichReminder = [Repeater repeaterWithName:[settingsInfo objectForKey:@"name"] inManagedObjectContext:context];// make this name match the correct repeater.
    */
    
    NSLog(@"Deadline Settings are: day = %@, time = %@, hour = %@, minute = %@, next = %@, last = %@, notify = %@, ordinal = %@, whichReminder = %@", deadline.day, deadline.time, deadline.hour, deadline.minute, deadline.next, deadline.last, deadline.notify, deadline.ordinal, deadline.whichReminder);
    
    return deadline;
}

+ (Deadline *)updateDeadline:(Deadline *)deadline
            withSettingsInfo:(NSDictionary *)settingsInfo
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSLog(@"Deadline+Settings updateDeadline: settingsInfo = %@", settingsInfo);
    /*
    Deadline *deadline = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deadline"];
    // predicate below is good to fetch one Repeater
    request.predicate = [NSPredicate predicateWithFormat:@"whichReminder = %@ AND day = %@", [settingsInfo objectForKey:@"name"], [settingsInfo objectForKey:@"day"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        // handle 
    } else {
        deadline = [matches lastObject];
        
        deadline.day = [settingsInfo objectForKey:@"day"];
        deadline.time = [settingsInfo objectForKey:@"time"];
        deadline.next = [settingsInfo objectForKey:@"next"];
        deadline.last = [settingsInfo objectForKey:@"last"];
        deadline.notify = [settingsInfo objectForKey:@"notify"];
        deadline.ordinal = [settingsInfo objectForKey:@"ordinal"];
        deadline.whichReminder = [Repeater repeaterWithName:[settingsInfo objectForKey:@"name"] inManagedObjectContext:context];// set this in repeater - done
    }
    */
    
    if (deadline) {
        deadline.day = [settingsInfo objectForKey:@"day"];
        deadline.time = [settingsInfo objectForKey:@"time"];
        deadline.hour = [settingsInfo objectForKey:@"hour"];
        deadline.minute = [settingsInfo objectForKey:@"minute"];
        deadline.next = [settingsInfo objectForKey:@"next"];
        deadline.last = [settingsInfo objectForKey:@"last"];
        deadline.notify = [settingsInfo objectForKey:@"notify"];
        deadline.ordinal = [settingsInfo objectForKey:@"ordinal"];
        deadline.whichReminder = [Repeater repeaterWithName:[settingsInfo objectForKey:@"name"] inManagedObjectContext:context];
        
        NSLog(@"Deadline Settings are: day = %@, time = %@, hour = %@, minute = %@, next = %@, last = %@, notify = %@, ordinal = %@, whichReminder = %@", deadline.day, deadline.time, deadline.hour, deadline.minute, deadline.next, deadline.last, deadline.notify, deadline.ordinal, deadline.whichReminder);
    } else {
        NSLog(@"Deadline+Settings: deadline is %@", deadline);
    }
    
    return deadline;
}

+ (void)removeDeadline:(Deadline *)deadline
inManagedObjectContext:(NSManagedObjectContext *)context
{
    [context deleteObject:deadline];
    return;
}

+(void)checkDeadlinesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Deadline"];
    //request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name]; want all repeaters
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        // handle error
        NSLog(@"checkDeadlinesInManagedObjectContext: !matches");
    } else {
        for (Deadline *dead in matches)
        {
            NSLog(@"checkDeadlinesInManagedObjectContext: Deadline Day = %@, next = %@", dead.day, dead.next);
        }
    }
    
}

@end
