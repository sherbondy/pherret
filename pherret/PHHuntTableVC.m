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
#import "PHTaskTableVC.h"
#import "PHDataHelpers.h"
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
        _dateTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLeftForVisibleCells) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_dateTimer forMode:@"NSDefaultRunLoopMode"];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateTimeLeftForVisibleCells
{
    for (UITableViewCell *cell in self.tableView.visibleCells){
        if ([cell isKindOfClass:[PHHuntCell class]]){
            [cell performSelector:@selector(refreshTimeLeft)];
        }
    }
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
        _content = [[_decoder objectWithData:fileData] objectForKey:@"data"];
    }
    
    return _content;
}

- (NSArray *)huntsForSection:(NSInteger)section
{
    if (!_myHunts){
        NSMutableArray *myHunts = [NSMutableArray new];
        NSMutableArray *availableHunts = [NSMutableArray new];
        NSString *username = [PHAppDelegate sharedDelegate].flickrUserName;
        for (NSDictionary *hunt in self.content){
            NSArray *participants = [hunt objectForKey:@"participants"];
            if ([PHDataHelpers participants:participants containsUser:username]){
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
    _content;
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
            return @"Public Hunts";
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
    cell.playerCount.text = [NSString stringWithFormat:@"%d", ((NSArray *)[item objectForKey:@"participants"]).count];
    cell.endDate = [NSDate dateWithTimeIntervalSince1970:[[item objectForKey:@"endDate"] doubleValue]];
    
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
    PHTaskTableVC *huntTaskVC = [[PHTaskTableVC alloc] init];
    huntTaskVC.huntInfo = [[self huntsForSection:indexPath.section] objectAtIndex:indexPath.row];
    [[PHAppDelegate sharedDelegate].navController pushViewController:huntTaskVC animated:YES];
}

@end
