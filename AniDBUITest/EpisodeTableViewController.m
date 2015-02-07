//
//  EpisodeTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "EpisodeTableViewController.h"
#import "EpisodeTableViewCell.h"
#import "BaseViewController.h"

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

- (void)configureCell:(EpisodeTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell forIndexPath:indexPath];
    Episode *episode = [self.contentController objectAtIndexPath:indexPath];
    [cell.episodeNumber setText:[episode episodeNumberString]];
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
    EpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEpisode"]) {
        Episode *episode = [self.contentController objectAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)sender]];
        [(BaseViewController *)segue.destinationViewController setRepresentedObject:episode];
    }
}

@end
