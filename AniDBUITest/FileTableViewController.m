//
//  FileTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 29.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "FileTableViewController.h"
#import "BaseViewController.h"

@interface FileTableViewController ()

@end

@implementation FileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Anime *anime = [(Episode *)self.representedObject anime];
    
    if ([[anime groupStatusesWithState:ADBGroupStatusOngoing] count] == 0 || [[anime groupStatusesWithState:ADBGroupStatusComplete] count] == 0 || [[anime groupStatusesWithState:ADBGroupStatusFinished] count] == 0)
        [self.anidb sendRequest:[anime groupStatusRequestWithState:ADBGroupStatusOngoingCompleteOrFinished]];
    if ([[anime groupStatusesWithState:ADBGroupStatusStalled] count] == 0)
        [self.anidb sendRequest:[anime groupStatusRequestWithState:ADBGroupStatusStalled]];
    if ([[anime groupStatusesWithState:ADBGroupStatusDropped] count] == 0)
        [self.anidb sendRequest:[anime groupStatusRequestWithState:ADBGroupStatusDropped]];
    if ([[anime groupStatusesWithState:ADBGroupStatusSpecialsOnly] count] == 0)
        [self.anidb sendRequest:[anime groupStatusRequestWithState:ADBGroupStatusSpecialsOnly]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureCell:(FileTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell forIndexPath:indexPath];
    File *file = [self.contentController objectAtIndexPath:indexPath];
    if ([file.fetched boolValue]) {
        [cell.video setText:[file shortVideoString]];
        [cell.audiosubs setText:[NSString stringWithFormat:@"%@ %@", [file shortDubsString], [file shortSubsString]]];
        [cell.size setText:[file binarySizeString]];
        [cell setLeftUtilityButtons:[self leftButtons]];
        [cell setDelegate:self];
    }
    else {
        if ([file.id isEqualToNumber:@0])
            [cell.video setText:@"Tap to load files for group"];
        else
            [cell.video setText:@"Tap to load file"];
        [cell.audiosubs setText:@""];
        [cell.size setText:@""];
    }
}

- (NSArray *)leftButtons {
    NSMutableArray *buttons = [NSMutableArray array];
    
    [buttons sw_addUtilityButtonWithColor:[UIColor greenColor] title:@"Watch"];
    
    return buttons;
}

#pragma mark - Anidb delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    [super connection:connection didReceiveResponse:response];
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldPerformSegueWithIdentifier:@"showFile" sender:[tableView cellForRowAtIndexPath:indexPath]]) {
        [self performSegueWithIdentifier:@"showFile" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.contentController.sections[section] name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Swipeable table view cell delegate

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    File *file = [self.contentController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    switch (index) {
        case 0:
            [self.anidb sendRequest:[ADBRequest requestMylistAddWithFileID:file.id andParameters:[ADBRequest parameterDictionaryWithViewed:YES]]];
            break;
            
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    File *file = [self.contentController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    if (state == kCellStateLeft)
        return [file.mylist.fetched boolValue];
    return YES;
}

-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showFile"]) {
        File *file = [self.contentController objectAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)sender]];
        if ([file.id isEqualToNumber:@0]) {
            [self.anidb fetch:file];
            return NO;
        }
        if (![file.fetched boolValue]) {
            [self.anidb fetch:file];
            [self.anidb sendRequest:file.mylistRequest];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFile"]) {
        File *file = [self.contentController objectAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)sender]];
        [(BaseViewController *)segue.destinationViewController setRepresentedObject:file];
    }
}

@end
