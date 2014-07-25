//
//  Deadline.h
//  Repeaters1
//
//  Created by Ransom Barber on 8/16/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Repeater;

@interface Deadline : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSNumber * hour;
@property (nonatomic, retain) NSDate * last;
@property (nonatomic, retain) NSNumber * minute;
@property (nonatomic, retain) NSDate * next;
@property (nonatomic, retain) NSString * notify;
@property (nonatomic, retain) NSString * ordinal;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) Repeater *whichReminder;

@end
