//
//  FileTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 29.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "FileTableViewController.h"
#import "FileTableViewCell.h"
#import "BaseViewController.h"

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

- (void)configureCell:(FileTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell forIndexPath:indexPath];
    File *file = [self.contentController objectAtIndexPath:indexPath];
    if ([file.fetched boolValue]) {
        [cell.video setText:[file shortVideoString]];
        [cell.audiosubs setText:[NSString stringWithFormat:@"%@ %@", [file shortDubsString], [file shortSubsString]]];
        [cell.size setText:[file binarySizeString]];
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
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
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
    FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showFile"]) {
        return [[(File *)[self.contentController objectAtIndexPath:[self.tableView indexPathForCell:sender]] fetched] boolValue];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFile"]) {
        File *file = [self.contentController objectAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)sender]];
        [segue.destinationViewController setTitle:[NSString stringWithFormat:@"File %@", file.id]];
        [(BaseViewController *)segue.destinationViewController setRepresentedObject:file];
    }
}

@end
