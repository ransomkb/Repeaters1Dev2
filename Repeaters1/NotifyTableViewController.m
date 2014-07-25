//
//  NotifyViewController.m
//  Repeaters1
//
//  Created by Ransom Barber on 7/27/12.
//  Copyright (c) 2012 Hart Book. All rights reserved.
//

#import "NotifyTableViewController.h"

@interface NotifyTableViewController ()
@property (nonatomic, strong) NSArray *preNotifiers;
@end

@implementation NotifyTableViewController

@synthesize preNotifiers = _preNotifiers;
@synthesize notifyTableView = _notifyTableView;
@synthesize notifier = _notifier;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        /* Autoreleased array */
        // example: NSArray *array = [NSArray arrayWithArray:mutableArray];
        //self.editTableView = [[UITableView alloc] initWithFrame:<#(CGRect)#> style:<#(UITableViewStyle)#>];
        
        [self.view addSubview:self.notifyTableView]; // maybe this should be in viewDidLoad
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.preNotifiers = [[NSArray alloc] initWithObjects:@"No Notifier", @"At Deadline", @"5 Minutes Before", @"15 Minutes Before", @"30 Minutes Before", @"One Hour Before", nil];
    
    selectedValueIndex = 0;
    self.notifier = @"No Notifier";
    
    //[self.view addSubview:self.notifyTableView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setNotifyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.preNotifiers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Notify Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [self.preNotifiers objectAtIndex:[indexPath row]];
    
    if ([indexPath row] == selectedValueIndex) // selectedValueIndex; this may not work; may need to adjust as in example online
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    //NSLog(@"cellForRow: selectedValueIndex = %d", selectedValueIndex);
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSLog(@"didSelectRow: indexPath.row = %d and selectedValueIndex = %d before setting", indexPath.row, selectedValueIndex);
    selectedValueIndex = indexPath.row;
    NSLog(@"didSelectRow: selectedValueIndex = %d after setting", selectedValueIndex);
    //UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView reloadData];

    self.notifier = [self.preNotifiers objectAtIndex:indexPath.row];
    NSLog(@"didSelectRow: self.notifier = %@ after setting", self.notifier);
}

- (IBAction)doneNotifier:(id)sender
{
    NSLog(@"doneNotifier: self.notifier = %@", self.notifier);
    [self.delegate NotifyTableViewController:self didGetNotifier:self.notifier];
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

@end
