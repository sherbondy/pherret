//
//  PHTaskTableVC.m
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "PHTaskTableVC.h"
#import "PHAppDelegate.h"
#import "PHMapView.h"
#import "PHDataHelpers.h"

@interface PHTaskTableVC ()

@end

@implementation PHTaskTableVC

@synthesize huntInfo = _huntInfo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"PHTaskTableVC" owner:self options:nil];
        _joinHuntView = [nibs objectAtIndex:0];
        
        _mapView = [[PHMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMap)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)toggleMap
{
    UIView *viewOne = _isTableViewHidden ? _mapView : self.tableView;
    UIView *viewTwo = _isTableViewHidden ? self.tableView : _mapView;
    [UIView transitionFromView:viewOne toView:viewTwo duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished){
        _isTableViewHidden = !_isTableViewHidden;
    }];
}

- (void)setHuntInfo:(NSDictionary *)huntInfo
{
    _huntInfo = huntInfo;
    self.title = [_huntInfo objectForKey:@"name"];
    
    if (![PHDataHelpers participants:[_huntInfo objectForKey:@"participants"] containsUser:[PHAppDelegate sharedDelegate].flickrUserName]){
        self.tableView.tableHeaderView = _joinHuntView;
    }
}

- (IBAction)joinHunt:(id)sender
{
    NSLog(@"Make the request to join the hunt!");
    // api call goes here
    
    [UIView animateWithDuration:0.4 animations:^{
        self.tableView.tableHeaderView.transform = CGAffineTransformMakeScale(1, 0.001);
    } completion:^(BOOL isComplete){
        self.tableView.tableHeaderView = nil;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
