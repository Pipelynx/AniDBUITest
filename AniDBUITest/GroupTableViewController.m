//
//  GroupTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "GroupTableViewController.h"
#import "GroupTableViewCell.h"
#import "BaseViewController.h"

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

- (void)configureCell:(GroupTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell forIndexPath:indexPath];
    Group *group = [[self.contentController objectAtIndexPath:indexPath] valueForKey:@"group"];
    if ([group.fetched boolValue]) {
        [cell.name setText:[NSString stringWithFormat:@"%@ [%@]", group.name, group.shortName]];
        [cell.rating setText:[NSString stringWithFormat:@"%.1f (%@)", group.rating.floatValue / 100, group.ratingCount]];
    }
    else {
        [cell.name setText:@"Tap to load Group"];
        [cell.rating setText:[NSString stringWithFormat:@"Group ID: %@", group.id]];
    }
}

- (BOOL)indexPath:(NSIndexPath *)indexPath hasManagedObject:(NSManagedObject *)object {
    return [[[[self.contentController objectAtIndexPath:indexPath] valueForKey:@"group"] objectID] isEqual:[object objectID]];
}

#pragma mark - Anidb delegate

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (![self shouldPerformSegueWithIdentifier:@"showGroup" sender:[self.tableView cellForRowAtIndexPath:indexPath]])
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
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showGroup"]) {
        return [[(Group *)[[self.contentController objectAtIndexPath:[self.tableView indexPathForCell:sender]] valueForKey:@"group"] fetched] boolValue];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGroup"]) {
        NSManagedObject *groupStatus = [self.contentController objectAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)sender]];
        [segue.destinationViewController setTitle:[[groupStatus valueForKey:@"group"] valueForKey:@"name"]];
        [(BaseViewController *)segue.destinationViewController setRepresentedObject:groupStatus];
    }
}

@end
