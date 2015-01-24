//
//  AnimeController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 16.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeController.h"
#import "AnimeDetailController.h"
#import "AnimeResultsController.h"

@interface AnimeController () <UISearchBarDelegate>

@property (nonatomic) BOOL lookingUp;

@end

@implementation AnimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    
    self.anidb = [ADBPersistentConnection sharedConnection];
    [self.anidb addDelegate:self];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Anime"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"romajiName" ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"fetched", @1]];
    
    self.animeController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.animeController setDelegate:self];
    
    error = nil;
    [self.animeController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Anime"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"romajiName" ascending:YES]]];
    [fetchRequest setPredicate:[self predicateWithSearchString:@""]];
    
    self.searchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.searchController setDelegate:self];
    
    error = nil;
    [self.searchController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

#pragma mark - ADBConnection delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    if (self.lookingUp) {
        if ([response[@"responseType"] intValue] == ADBResponseCodeNoSuchAnime) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No such anime in AniDB" message:@"The name has to be an exact match, including spaces but not case for any title associated with this anime" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        self.lookingUp = NO;
    }
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    if ([response.entity.name isEqualToString:@"Anime"]) {
        self.lookingUp = NO;
    }
    
    NSError *error = nil;
    if (![self.anidb save:&error])
        NSLog(@"%@, %@", error, error.localizedDescription);
    error = nil;
    [self.animeController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    error = nil;
    [self.searchController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (controller == self.animeController)
        [self.tableView beginUpdates];
    else
        [self.searchDisplayController.searchResultsTableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (controller == self.animeController)
        [self.tableView endUpdates];
    else
        [self.searchDisplayController.searchResultsTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    __weak UITableView *tableView = (controller == self.animeController) ? self.tableView : self.searchDisplayController.searchResultsTableView;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] forAnime:(Anime *)[controller objectAtIndexPath:indexPath]];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - Table view data source delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static UITableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"AnimeCell"];
    });
    if (tableView == self.tableView)
        [self configureCell:sizingCell forAnime:(Anime *)[self.animeController objectAtIndexPath:indexPath]];
    else
        [self configureCell:sizingCell forAnime:(Anime *)[self.searchController objectAtIndexPath:indexPath]];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView)
        return [self.animeController.sections count];
    else
        return [self.searchController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections;
    if (tableView == self.tableView)
        sections = self.animeController.sections;
    else
        sections = self.searchController.sections;
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AnimeCell"];
    if (tableView == self.tableView)
        [self configureCell:cell forAnime:(Anime *)[self.animeController objectAtIndexPath:indexPath]];
    else
        [self configureCell:cell forAnime:(Anime *)[self.searchController objectAtIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Anime *selectedAnime = (tableView == self.tableView) ? [self.animeController objectAtIndexPath:indexPath] : [self.searchController objectAtIndexPath:indexPath];
    //NSLog(@"Did select \"%@\" Content view frame origin x: %f", selectedAnime.romajiName, [tableView cellForRowAtIndexPath:indexPath].contentView.frame.origin.x);
    
    AnimeDetailController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"AnimeDetail"];
    [detailController setRepresentedObject:selectedAnime];
    
    [self.navigationController pushViewController:detailController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Displaying \"%@\"", [(UILabel *)[cell viewWithTag:402] text]);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Anime *selectedAnime = (tableView == self.tableView) ? [self.animeController objectAtIndexPath:indexPath] : [self.resultsController.animeController objectAtIndexPath:indexPath];
    NSLog(@"Will select \"%@\" Content view frame origin x: %f", selectedAnime.romajiName, [tableView cellForRowAtIndexPath:indexPath].contentView.frame.origin.x);
    return indexPath;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    Anime *selectedAnime = (tableView == self.tableView) ? [self.animeController objectAtIndexPath:indexPath] : [self.resultsController.animeController objectAtIndexPath:indexPath];
    NSLog(@"Will deselect \"%@\" Content view frame origin x: %f", selectedAnime.romajiName, [tableView cellForRowAtIndexPath:indexPath].contentView.frame.origin.x);
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    Anime *selectedAnime = (tableView == self.tableView) ? [self.animeController objectAtIndexPath:indexPath] : [self.resultsController.animeController objectAtIndexPath:indexPath];
    NSLog(@"Did deselect \"%@\" Content view frame origin x: %f", selectedAnime.romajiName, [tableView cellForRowAtIndexPath:indexPath].contentView.frame.origin.x);
}*/

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if (!self.lookingUp) {
        [self.anidb sendRequest:[ADBRequest createAnimeWithName:searchBar.text]];
        self.lookingUp = YES;
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    AnimeResultsController *resultsController = (AnimeResultsController *)searchController.searchResultsController;
    [resultsController.animeController.fetchRequest setPredicate:[self predicateWithSearchString:searchController.searchBar.text]];
    //[resultsController.animeController.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"fetched", @1]];
    
    NSError *error = nil;
    [resultsController.animeController performFetch:&error];
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    [resultsController.tableView reloadData];
}

- (NSPredicate*)predicateWithSearchString:(NSString*)searchString {
    NSPredicate *fetched = [NSPredicate predicateWithFormat:@"fetched == 1"];
    NSCompoundPredicate *namesContain = [NSCompoundPredicate orPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"romajiName contains[cd] $SEARCH"], [NSPredicate predicateWithFormat:@"kanjiName contains[cd] $SEARCH"], [NSPredicate predicateWithFormat:@"englishName contains[cd] $SEARCH"]]];
    NSCompoundPredicate *finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[fetched, namesContain]];
    return [finalPredicate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:searchString, @"SEARCH", nil]];
}

@end
