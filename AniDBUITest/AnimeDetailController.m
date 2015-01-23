//
//  AnimeDetailController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 18.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeDetailController.h"
#import "Episode.h"
#import "UIImageView+WebCache.h"

@interface AnimeDetailController ()

@property (nonatomic) BOOL lookingUp;

@end

@implementation AnimeDetailController

@synthesize representedObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EpisodeCell" bundle:nil] forCellReuseIdentifier:@"EpisodeCell"];
    
    self.anidb = [ADBPersistentConnection sharedConnection];
    [self.anidb addDelegate:self];
    
    [self.mainName setText:representedObject.romajiName];
    if ([representedObject.romajiName isEqualToString:representedObject.englishName])
        [self.otherNames setText:representedObject.kanjiName];
    else
        [self.otherNames setText:[NSString stringWithFormat:@"%@ (%@)", representedObject.kanjiName, representedObject.englishName]];
    [self.type setText:[NSString stringWithFormat:@"%@, %@ episode%@", representedObject.type, representedObject.numberOfEpisodes, [representedObject.numberOfEpisodes isEqualToNumber:@1]?@"":@"s"]];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    [self.aired setText:[NSString stringWithFormat:@"First aired on %@,\nended on %@", [df stringFromDate:representedObject.airDate], [df stringFromDate:representedObject.endDate]]];
    [self.rating setText:[NSString stringWithFormat:@"Rated %.1f out of %@ votes", representedObject.rating.floatValue / 100, representedObject.ratingCount]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Episode"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"episodeNumber" ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K != %@", @"anime.id", representedObject.id, @"fetched", @(-1)]];
    
    self.episodeController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.episodeController setDelegate:self];
    
    NSError *error = nil;
    [self.episodeController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

#pragma mark - ADBConnection delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    if (self.lookingUp)
        if ([response[@"responseType"] intValue] == ADBResponseCodeNoSuchEpisode) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No such episode in AniDB" message:@"This episode number is not available for this anime. The UDP API information is sometimes vague, and episode numbers have to be inferred from episode counts. This episode has been marked as nonexistant and if you try to load it again, the next episode number will be tried, this way hopefully you will eventually get the correct one." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            
            NSString *episodeNumberString = [ADBRequest extractAttribute:@"epno" fromRequest:response[@"request"]];
            [self.anidb invalidate:[self.anidb getEpisodeWithAnimeID:representedObject.id episodeNumber:[Episode getEpisodeNumberFromEpisodeNumberString:episodeNumberString] andType:[Episode getTypeFromEpisodeNumberString:episodeNumberString]]];
            
            [self.tableView reloadData];
            self.lookingUp = NO;
        }
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    if ([response.entity.name isEqualToString:@"Episode"]) {
        self.lookingUp = NO;
    }
    
    NSError *error = nil;
    if (![self.anidb save:&error])
        NSLog(@"%@, %@", error, error.localizedDescription);
    error = nil;
    error = nil;
    [self.episodeController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] forEpisode:(Episode *)[controller objectAtIndexPath:indexPath]];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - Table view data source delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.episodeController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([[self.episodeController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.episodeController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EpisodeCell"];
    [self configureCell:cell forEpisode:[self.episodeController objectAtIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Episode *episode = (Episode *)[self.episodeController objectAtIndexPath:indexPath];
    NSLog(@"Real index path: %@", indexPath);
    if (![episode.fetched boolValue] && !self.lookingUp) {
        [self.anidb sendRequest:[episode getRequest]];
        self.lookingUp = YES;
    }
}

- (void)configureCell:(UITableViewCell *)cell forEpisode:(Episode *)episode {
    [cell.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [(UILabel *)[cell viewWithTag:502] setText:episode.romajiName];
    if ([episode.romajiName isEqualToString:episode.englishName])
        [(UILabel *)[cell viewWithTag:503] setText:episode.kanjiName];
    else {
        [(UILabel *)[cell viewWithTag:503] setText:episode.kanjiName];
        [(UILabel *)[cell viewWithTag:504] setText:episode.englishName];
    }
    [(UILabel *)[cell viewWithTag:501] setText:[episode getEpisodeNumberString]];
}

@end
