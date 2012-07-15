//
//  PHHuntTableVC.m
//  pherret
//
//  Created by Ethan Sherbondy on 7/14/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "PHHuntTableVC.h"
#import "PHHuntCell.h"
#import "PHAppDelegate.h"
#import <AFNetworking/AFnetworking.h>
#import <JSONKit/JSONKit.h>

static const NSInteger kMyHuntsSection = 0;
static const NSInteger kAvailableHuntsSection = 1;

@interface PHHuntTableVC ()

@end

@implementation PHHuntTableVC

@synthesize content = _content;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (NSArray *)content {
    if (!_content){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dummy_hunts" ofType:@"json"];
        
        /*
        NSURL *url = [NSURL URLWithString:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"Content: %@", JSON);
            _content = JSON;
        } failure:nil];
        [operation start];
         */
        
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        if (!_decoder) {
            _decoder = [[JSONDecoder alloc] init];
        }
        _content = [[_decoder objectWithData:fileData] objectForKey:@"content"];
    }
    
    return _content;
}

- (NSArray *)huntsForSection:(NSInteger)section
{
    if (!_myHunts){
        NSMutableArray *myHunts = [NSMutableArray new];
        NSMutableArray *availableHunts = [NSMutableArray new];
        for (NSDictionary *hunt in self.content){
            if ([[hunt objectForKey:@"participants"] containsObject:[PHAppDelegate sharedDelegate].flickrUserName]){
                [myHunts addObject:hunt];
            } else {
                [availableHunts addObject:hunt];
            }
        }
        
        _myHunts = myHunts;
        _availableHunts = availableHunts;
    }
    
    switch (section) {
        case kMyHuntsSection:
            return _myHunts;
        case kAvailableHuntsSection:
            return _availableHunts;
        default:
            return nil;
    }
}

- (void)reloadTableView
{
    _myHunts = nil;
    _availableHunts = nil;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kMyHuntsSection:
            return @"My Hunts";
        case kAvailableHuntsSection:
            return @"Available Hunts";
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self huntsForSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HuntCell";
    PHHuntCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[PHHuntCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    NSDictionary *item = [[self huntsForSection:indexPath.section] objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.nameLabel.text = [item objectForKey:@"name"];
    cell.locationLabel.text = [item objectForKey:@"location"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

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
