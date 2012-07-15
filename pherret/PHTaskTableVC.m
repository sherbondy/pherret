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
#import "PHTaskViewController.h"
#import <JSONKit/JSONKit.h>

@interface PHTaskTableVC ()

@end

@implementation PHTaskTableVC

@synthesize huntInfo = _huntInfo;
@synthesize tasks = _tasks;

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

- (void)setTasks:(NSArray *)tasks {
    _tasks = tasks;

    [_mapView removeAllPins];
    for (NSDictionary *task in tasks){
        for (NSDictionary *photo in [task objectForKey:@"photos"]){
            [_mapView addPinAtLocation:[photo objectForKey:@"geolocation"]];
        }
    }    
}

- (NSArray *)tasks {
    return _tasks;
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
    
    _isParticipant = [PHDataHelpers participants:[_huntInfo objectForKey:@"participants"]
                                    containsUser:[PHAppDelegate sharedDelegate].flickrUserName];
    
    if (!_taskVC){
        _taskVC = [[PHTaskViewController alloc] initWithDelegate:self];
    }

    if (!_isParticipant){
        self.tableView.tableHeaderView = _joinHuntView;
    }
    
    [self setTasks:[huntInfo objectForKey:@"tasks"]];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *task = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = [task objectForKey:@"name"];
    
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

    _selectedTaskIndex = indexPath.row;
    _taskVC.task = [self.tasks objectAtIndex:_selectedTaskIndex];
    [self.navigationController pushViewController:_taskVC animated:YES];
}

- (void)moveToNextTask
{
    NSUInteger nextIndex = _selectedTaskIndex + 1;
    if (nextIndex < self.tasks.count){
        _selectedTaskIndex = nextIndex;
        _taskVC.task = [self.tasks objectAtIndex:_selectedTaskIndex];
    }
}
- (void)moveToPrevTask
{
    NSUInteger prevIndex = _selectedTaskIndex - 1;
    if (prevIndex < self.tasks.count){
        _selectedTaskIndex = prevIndex;
        _taskVC.task = [self.tasks objectAtIndex:prevIndex];
    }
}

@end
