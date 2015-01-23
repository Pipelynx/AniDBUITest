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

@interface AnimeController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) AnimeResultsController *resultsController;
@property (nonatomic) BOOL lookingUp;

@end

@implementation AnimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    
    self.anidb = [ADBPersistentConnection sharedConnection];
    [self.anidb addDelegate:self];
    
    _resultsController = [[AnimeResultsController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    
    @try {
        //[[NSUserDefaults standardUserDefaults] setValue:@"pipelynx" forKey:@"username_preference"];
        //[[NSUserDefaults standardUserDefaults] setValue:@"Swc5gzFPAjn985GjnD3z" forKey:@"password_preference"];
        if (self.anidb.isLoggedIn)
            [[NSUserDefaults standardUserDefaults] setURL:self.anidb.getImageServer forKey:@"imageServer"];
        else
            [self.anidb loginWithUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"username_preference"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"password_preference"]];
        
        /*[self.anidb newAnimeWithID:@8691 andFetch:YES];
        [self.anidb newAnimeWithID:@8692 andFetch:YES];
        [self.anidb newAnimeWithID:@9187 andFetch:YES];
        [self.anidb newAnimeWithID:@10022 andFetch:YES];
        [self.anidb newAnimeWithID:@10376 andFetch:YES];*/
        
        [self.anidb sendRequest:[ADBRequest createGroupStatusWithAnimeID:@69]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        [self.anidb logout];
    }
    
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
    
    self.resultsController.animeController = [[NSFetchedResultsController alloc] initWithFetchRequest:[fetchRequest copy] managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.resultsController.animeController setDelegate:self.resultsController];
    
    error = nil;
    [self.resultsController.animeController performFetch:&error];
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
    [self.resultsController.animeController performFetch:&error];
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
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] forAnime:(Anime *)[controller objectAtIndexPath:indexPath]];
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static UITableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"AnimeCell"];
    });
    [self configureCell:sizingCell forAnime:(Anime *)[self.animeController objectAtIndexPath:indexPath]];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.animeController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.animeController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AnimeCell"];
    [self configureCell:cell forAnime:(Anime *)[self.animeController objectAtIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Anime *selectedAnime = (tableView == self.tableView) ? [self.animeController objectAtIndexPath:indexPath] : [self.resultsController.animeController objectAtIndexPath:indexPath];
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
