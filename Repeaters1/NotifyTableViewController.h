//
//  NotifyViewController.h
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotifyTableViewController;

@protocol NotifyTableViewControllerDelegate <NSObject>

- (void)NotifyTableViewController:(NotifyTableViewController *)sender
                   didGetNotifier:(NSString *)notifier;
@end

@interface NotifyTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int selectedValueIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *notifyTableView;
@property (nonatomic, copy) NSString *notifier;
@property (nonatomic, weak) id <NotifyTableViewControllerDelegate> delegate;

@end
