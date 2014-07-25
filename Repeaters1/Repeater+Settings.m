//
//  Repeater+Settings.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "Repeater+Settings.h"
//#import "Deadline+Settings.h"

@implementation Repeater (Settings)

+ (Repeater *)repeaterWithName:(NSString *)name
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Repeater *repeater = nil;
    
     NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Repeater"];
     request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
     NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
     request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
     
     NSError *error = nil;
     NSArray *matches = [context executeFetchRequest:request error:&error];
    
     if (!matches || ([matches count] > 1)) {
         // handle error
     } else if (![matches count]) {
         repeater = [NSEntityDescription insertNewObjectForEntityForName:@"Repeater" inManagedObjectContext:context];
         repeater.name = name;
     } else {
         // IMPORTANT: should add some code to inform user that they already have such a repeater and ask if wish to add or change the deadline, or change the name
         repeater = [matches lastObject];
     }
    
    return repeater;
}

+ (void)removeLastRepeater:(NSString *)name
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    Repeater *repeater = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Repeater"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name]; // want only this repeater
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
        NSLog(@"removeLastRepeater: !matches or more than one repeater");
    } else {
        repeater = [matches lastObject];
        if (!repeater.deadlines || ([repeater.deadlines count] == 0)) {
            //[context deleteObject:[repeater.deadlines anyObject]];
            [context deleteObject:repeater];
            NSLog(@"removeLastRepeater: [repeater.deadlines count] <= 1, so repeater deleted");
            return;
        } else {
            NSLog(@"removeLastRepeater: [repeater.deadlines count] > 1, so repeater not deleted");
        }
    }
}

+(void)checkRepeatersInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Repeater"];
    //request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name]; want all repeaters 
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        // handle error
        NSLog(@"checkRepeatersInManagedObjectContext: !matches");
    } else {
        for (Repeater *rep in matches)
        {
            NSLog(@"checkRepeatersInManagedObjectContext: Repeater name = %@", rep.name);
        }
    }

}

@end
