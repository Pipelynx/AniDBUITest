//
//  AnimeController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 16.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeController.h"
#import "AnimeCell.h"

@implementation AnimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.anidb = [ADBPersistentConnection sharedConnection];
    [self.anidb addDelegate:self];
    
    //[self.anidb loginWithUsername:@"pipelynx" andPassword:@"Swc5gzFPAjn985GjnD3z"];
    
    /*NSMutableArray *temp = [NSMutableArray array];
    [temp addObject:[self.anidb newAnimeWithID:@8692 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@10022 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@8691 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@10376 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@9187 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@239 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@4880 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@8387 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@9685 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@3030 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@4421 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@1456 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@8159 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@7228 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@7483 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@8312 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@8384 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@8943 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@5178 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@5914 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@6503 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@9023 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@9588 andFetch:YES]];
    [temp addObject:[self.anidb newAnimeWithID:@10961 andFetch:YES]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Episode"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", @"fetched", @NO]];
    NSError *error = nil;
    NSArray *result = [self.anidb.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        for (Episode *episode in result) {
            [self.anidb sendRequest:[episode getRequest]];
        }
    }
    else {
        NSLog(@"%@, %@", error, error.localizedDescription);
    }*/

    //[self.anidb logout];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Anime"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"romajiName" ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K != %@", @"romajiName", @""]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    
    error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    NSError *error = nil;
    if (![self.anidb save:&error])
        NSLog(@"%@, %@", error, error.localizedDescription);
}

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
            [self configureCell:(AnimeCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)configureCell:(AnimeCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Anime *anime = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    if (anime.romajiName) {
        [cell.romajiName setText:anime.romajiName];
        [cell.type setText:[NSString stringWithFormat:@"%@, %@ episode%@\n%@ - %@", anime.type, anime.numberOfEpisodes, [anime.numberOfEpisodes isEqualToNumber:@1]?@"":@"s", [df stringFromDate:anime.airDate], [df stringFromDate:anime.endDate]]];
    }
    else {
        [cell.romajiName setText:@"Anime not yet loaded"];
        [cell.type setText:[NSString stringWithFormat:@"Anime ID: %@", anime.id]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnimeCell"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

@end
