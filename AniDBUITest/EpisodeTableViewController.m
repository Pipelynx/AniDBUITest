//
//  EpisodeTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "EpisodeTableViewController.h"
#import "EpisodeTableViewCell.h"

@interface EpisodeTableViewController ()

@end

@implementation EpisodeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(EpisodeTableViewCell *)cell forEpisode:(Episode *)episode {
    [cell.episodeNumber setText:[episode getEpisodeNumberString]];
    if ([episode.fetched boolValue]) {
        [cell.mainName setText:episode.romajiName];
        [cell.secondaryName setText:episode.kanjiName];
        [cell.tertiaryName setText:episode.englishName];
    }
    else {
        [cell.mainName setText:@"Tap to load episode"];
        [cell.secondaryName setText:@""];
        [cell.tertiaryName setText:@""];
    }
}

#pragma mark - Anidb delegate

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
    NSIndexPath *remove = nil;
    EpisodeTableViewCell *cell;
    for (NSIndexPath *indexPath in self.busyIndexPaths) {
        cell = (EpisodeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
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
    if (![self.busyIndexPaths containsObject:indexPath])
        [((EpisodeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).activity startAnimating];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ([[self.contentController.sections[section] name] intValue]) {
        case ADBEpisodeTypeCredits:
            return @"Credits";
        case ADBEpisodeTypeSpecial:
            return @"Specials";
        case ADBEpisodeTypeTrailer:
            return @"Trailers";
        case ADBEpisodeTypeParody:
            return @"Parodies";
        case ADBEpisodeTypeOther:
            return @"Others";
        case ADBEpisodeTypeNormal:
            return @"Episodes";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forEpisode:[self.contentController objectAtIndexPath:indexPath]];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEpisode"]) {
        [segue.destinationViewController setTitle:self.title];
    }
}

@end
