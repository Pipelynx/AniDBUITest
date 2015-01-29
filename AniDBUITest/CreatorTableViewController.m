//
//  CreatorTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "CreatorTableViewController.h"
#import "CreatorTableViewCell.h"

@interface CreatorTableViewController ()

@end

@implementation CreatorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(CreatorTableViewCell *)cell forCharacterInfo:(NSManagedObject *)characterInfo {
    Creator *creator = [characterInfo valueForKey:@"creator"];
    if ([creator.fetched boolValue]) {
        [cell.creatorImage sd_setImageWithURL:[creator getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]]];
        [cell.mainName setText:creator.romajiName];
        [cell.secondaryName setText:creator.kanjiName];
        [cell.type setText:[self translateType:creator.type]];
    }
    else {
        [cell.creatorImage setImage:nil];
        [cell.mainName setText:@"Tap to load Creator"];
        [cell.secondaryName setText:[NSString stringWithFormat:@"Creator ID: %@", creator.id]];
        if (creator.romajiName)
            [cell.type setText:[NSString stringWithFormat:@"Creator name: %@", creator.romajiName]];
        else
            [cell.type setText:@""];
    }
}

- (NSString *)translateType:(NSNumber *)type {
    NSString *returnType = nil;
    switch ([type intValue]) {
        case 1: returnType = @"Person"; break;
        case 2: returnType = @"Company"; break;
        case 3: returnType = @"Collaboration"; break;
    }
    return returnType;
}

#pragma mark - Anidb delegate

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
    NSIndexPath *remove = nil;
    CreatorTableViewCell *cell;
    for (NSIndexPath *indexPath in self.busyIndexPaths) {
        cell = (CreatorTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([[[[self.contentController objectAtIndexPath:indexPath] valueForKey:@"creator"] objectID] isEqual:[response objectID]]) {
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
    if (![self.busyIndexPaths containsObject:indexPath])
        [((CreatorTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).activity startAnimating];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ([[self.contentController.sections[section] name] intValue]) {
        case 1:
            return @"Main creator";
        case 0:
            return @"Creator";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forCharacterInfo:[self.contentController objectAtIndexPath:indexPath]];
    
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
