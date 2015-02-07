//
//  AnimeTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 25.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeTableViewController.h"
#import "AnimeTableViewCell.h"
#import "LoginViewController.h"

@interface AnimeTableViewController ()

@property BOOL searching;

@end

@implementation AnimeTableViewController

@synthesize searching;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    searching = NO;
    
    [self fetchSearchResultsController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchSearchResultsController {
    NSError *error = nil;
    [self.searchResultsController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
}

- (IBAction)logout:(id)sender {
    [self.anidb logout];
    [(LoginViewController *)self.presentingViewController setLoggedOut:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Anidb connection delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    [super connection:connection didReceiveResponse:response];
    if ([response hasResponseCode:ADBResponseCodeNoSuchAnime]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No such anime!" message:@"The anime was not found. Please note that the search term has to be an exact non-case sensitive match of any name associated with this anime." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
    
    if ([response.entity.name isEqualToString:AnimeEntityIdentifier]) {
        Anime *anime = (Anime *)response;
        if (anime.fetched.intValue < 4095)
            [self.anidb fetch:anime];
    }
    
    [self fetchSearchResultsController];
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    if ([response.entity.name isEqualToString:AnimeEntityIdentifier])
        searching = NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Anime *anime = nil;
    if (tableView == self.tableView)
        anime = [self.contentController objectAtIndexPath:indexPath];
    else
        anime = [self.searchResultsController objectAtIndexPath:indexPath];
    if ([anime.fetched intValue] < 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:anime.romajiName message:[NSString stringWithFormat:@"Basic data is being downloaded, it will be accessible once that is complete."] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        if (![anime.fetching boolValue]) {
            [self.anidb fetch:anime];
        }
    }
}

#pragma mark - Table view data source

- (void)configureCell:(AnimeTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    Anime *anime = nil;
    if (cell.tableView == self.tableView)
        anime = [self.contentController objectAtIndexPath:indexPath];
    else
        anime = [self.searchResultsController objectAtIndexPath:indexPath];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    if ([anime isFetched:ADBAnimeFetchedAnime]) {
        [cell.animeImage sd_setImageWithURL:[anime getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]]];
        [cell.mainName setText:anime.romajiName];
        [cell.type setText:[NSString stringWithFormat:@"%@, %@ %@", anime.type, [anime.numberOfEpisodes isEqualToNumber:@0]?@"?":anime.numberOfEpisodes, [anime.numberOfEpisodes isEqualToNumber:@1]?@"episode":@"episodes"]];
        [cell.aired setText:[NSString stringWithFormat:@"Aired %@ - %@", [df stringFromDate:anime.airDate], [df stringFromDate:anime.endDate]]];
    }
    else {
        [cell.animeImage setImage:nil];
        [cell.mainName setText:@"Tap to load anime"];
        [cell.type setText:[NSString stringWithFormat:@"Anime ID: %@", anime.id]];
        [cell.aired setText:@""];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView)
        return [self.contentController.sections[section] numberOfObjects];
    else
        return [self.searchResultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.tableView = tableView;
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - Search display controller delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchResultsController.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"fetched > 0 && ( romajiName contains[cd] %@ || kanjiName contains[cd] %@ || englishName contains[cd] %@ )", searchString, searchString, searchString]];
    [self fetchSearchResultsController];
    
    return YES;
}

#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!searching) {
        [self.anidb sendRequest:[ADBRequest requestAnimeWithName:searchBar.text]];
        searching = YES;
    }
}

#pragma mark Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showAnime"]) {
        Anime *anime = nil;
        
        NSIndexPath *indexPath = [((AnimeTableViewCell *)sender).tableView indexPathForCell:(AnimeTableViewCell *)sender];
        if (((AnimeTableViewCell *)sender).tableView == self.tableView)
            anime = [self.contentController objectAtIndexPath:indexPath];
        else
            anime = [self.searchResultsController objectAtIndexPath:indexPath];
        
        return [anime.fetched intValue] >= 4095;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAnime"]) {
        Anime *anime = nil;
        
        NSIndexPath *indexPath = [((AnimeTableViewCell *)sender).tableView indexPathForCell:(AnimeTableViewCell *)sender];
        if (((AnimeTableViewCell *)sender).tableView == self.tableView)
            anime = [self.contentController objectAtIndexPath:indexPath];
        else
            anime = [self.searchResultsController objectAtIndexPath:indexPath];
        UITabBarController *tabController = (UITabBarController *)segue.destinationViewController;
        
        //Set represented Object for anime detail view
        [(BaseViewController *)tabController.viewControllers[0] setRepresentedObject:anime];
        
        //Setting a common predicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"anime.id == %@", anime.id];
        
        BaseTableViewController *episodeListController = tabController.viewControllers[1];
        BaseTableViewController *groupListController = tabController.viewControllers[2];
        BaseTableViewController *characterListController = tabController.viewControllers[3];
        BaseTableViewController *creatorListController = tabController.viewControllers[4];
        
        //Set content controller for episode list view
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:EpisodeEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"episodeNumber" ascending:YES]]];
        [fetchRequest setPredicate:predicate];
        [episodeListController setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:@"type" cacheName:nil]];
        
        //Set content controller for group list view
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:GroupStatusEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"completionState" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"group.name" ascending:YES]]];
        [fetchRequest setPredicate:predicate];
        [groupListController setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:@"completionState" cacheName:nil]];
        
        //Set content controller for character list view
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CharacterInfoEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"appearanceType" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"character.romajiName" ascending:YES]]];
        [fetchRequest setPredicate:predicate];
        [characterListController setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:@"appearanceType" cacheName:nil]];
        
        //Set content controller for creator list view
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CreatorInfoEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"isMainCreator" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"creator.romajiName" ascending:YES]]];
        [fetchRequest setPredicate:predicate];
        [creatorListController setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:@"isMainCreator" cacheName:nil]];
        
    }
}

@end
