//
//  GroupTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "GroupTableViewController.h"
#import "GroupTableViewCell.h"

@interface GroupTableViewController ()

@end

@implementation GroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(GroupTableViewCell *)cell forGroupStatus:(NSManagedObject *)groupStatus {
    Group *group = [groupStatus valueForKey:@"group"];
    if ([group.fetched boolValue]) {
        [cell.name setText:[NSString stringWithFormat:@"%@ [%@]", group.name, group.shortName]];
        [cell.rating setText:[NSString stringWithFormat:@"%.1f (%@)", group.rating.floatValue / 100, group.ratingCount]];
    }
    else {
        [cell.name setText:@"Tap to load Group"];
        [cell.rating setText:[NSString stringWithFormat:@"Group ID: %@", group.id]];
    }
}

#pragma mark - Anidb delegate

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
    NSIndexPath *remove = nil;
    GroupTableViewCell *cell;
    for (NSIndexPath *indexPath in self.busyIndexPaths) {
        cell = (GroupTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([[[[self.contentController objectAtIndexPath:indexPath] valueForKey:@"group"] objectID] isEqual:[response objectID]]) {
            [cell.activity stopAnimating];
            remove = indexPath;
        }
        else
            [cell.activity startAnimating];
    }
    if (remove)
        [self.busyIndexPaths removeObject:remove];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (![self.busyIndexPaths containsObject:indexPath])
        [((GroupTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).activity startAnimating];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ([[self.contentController.sections[section] name] intValue]) {
        case ADBGroupStatusOngoing:
            return @"Ongoing";
        case ADBGroupStatusStalled:
            return @"Stalled";
        case ADBGroupStatusComplete:
            return @"Complete";
        case ADBGroupStatusDropped:
            return @"Dropped";
        case ADBGroupStatusFinished:
            return @"Finished";
        case ADBGroupStatusSpecialsOnly:
            return @"Specials only";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forGroupStatus:[self.contentController objectAtIndexPath:indexPath]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
