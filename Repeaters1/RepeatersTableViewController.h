//
//  RepeatersViewController.h
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"


@interface RepeatersTableViewController : CoreDataTableViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIManagedDocument *repeaterDatabase;
@property (nonatomic, strong) NSDictionary *settingsInfo;

@end
