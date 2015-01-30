//
//  FileTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 29.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "FileTableViewController.h"
#import "FileTableViewCell.h"

@interface FileTableViewController ()

@end

@implementation FileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(FileTableViewCell *)cell forFile:(File *)file {
    
    if ([file.fetched boolValue]) {
        [cell.video setText:[file getVideoString]];
        [cell.audiosubs setText:[NSString stringWithFormat:@"%@ %@", [file getDubsString], [file getSubsString]]];
        [cell.size setText:[file getBinarySizeString]];
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

#pragma mark - Anidb delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    [super connection:connection didReceiveResponse:response];
    NSIndexPath *remove = nil;
    FileTableViewCell *cell;
    for (NSIndexPath *indexPath in self.busyIndexPaths) {
        cell = (FileTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        for (NSString *fileID in response[@"fileIDs"]) {
            if ([[(File *)[self.contentController objectAtIndexPath:indexPath] id] isEqualToNumber:[NSNumber numberWithString:fileID]]) {
                [cell.activity stopAnimating];
                remove = indexPath;
                break;
            }
            else
                [cell.activity startAnimating];
        }
    }
    if (remove) {
        [self.busyIndexPaths removeObject:remove];
    }
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
    NSIndexPath *remove = nil;
    FileTableViewCell *cell;
    for (NSIndexPath *indexPath in self.busyIndexPaths) {
        cell = (FileTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([[[self.contentController objectAtIndexPath:indexPath] objectID] isEqual:[response objectID]]) {
            [cell.activity stopAnimating];
            remove = indexPath;
        }
        else
            [cell.activity startAnimating];
    }
    if (remove) {
        [self.busyIndexPaths removeObject:remove];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (![[(File *)[self.contentController objectAtIndexPath:indexPath] fetched] boolValue])
        [((FileTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).activity startAnimating];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.contentController.sections[section] name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forFile:[self.contentController objectAtIndexPath:indexPath]];
    
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
