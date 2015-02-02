//
//  AnimeTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 25.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeTableViewController.h"
#import "AnimeTableViewCell.h"
#import "AnimeViewController.h"

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

#pragma mark - Anidb connection delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    [super connection:connection didReceiveResponse:response];
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
    
    [self fetchSearchResultsController];
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    if ([response.entity.name isEqualToString:AnimeEntityIdentifier])
        searching = NO;
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
    
    if ([anime getFetchedBits:ADBAnimeFetchedAnime]) {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAnime"]) {
        Anime *anime = nil;
        NSIndexPath *indexPath = [((AnimeTableViewCell *)sender).tableView indexPathForCell:(AnimeTableViewCell *)sender];
        if (((AnimeTableViewCell *)sender).tableView == self.tableView)
            anime = [self.contentController objectAtIndexPath:indexPath];
        else
            anime = [self.searchResultsController objectAtIndexPath:indexPath];
        [(AnimeViewController *)segue.destinationViewController setRepresentedObject:anime];
    }
}

@end
