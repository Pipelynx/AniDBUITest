//
//  AnimeTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 25.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "AnimeTableViewController.h"
#import "AnimeTableViewCell.h"
#import "AnimeViewController.h"

@interface AnimeTableViewController ()

@property ADBPersistentConnection *anidb;

@end

@implementation AnimeTableViewController

@synthesize anidb;
@synthesize animeController;
@synthesize searchResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    anidb = [ADBPersistentConnection sharedConnection];
    [anidb addDelegate:self];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:AnimeEntityIdentifier];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"romajiName" ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"fetched > 0"]];
    
    animeController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:anidb.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    [animeController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
    
    /*Anime *anime = [anidb newAnimeWithID:@8692 andFetch:YES];
    [anidb newAnimeWithID:@10022 andFetch:YES];
    [anidb newAnimeWithID:@8691 andFetch:YES];
    [anidb newAnimeWithID:@9187 andFetch:YES];
    [anidb newAnimeWithID:@10376 andFetch:YES];
    
    [anidb sendRequest:[anime getGroupStatusRequestWithState:1]];
    
    [anidb sendRequest:[anime getGroupStatusRequestWithState:0]];
    [anidb sendRequest:[anime getGroupStatusRequestWithState:2]];
    [anidb sendRequest:[anime getGroupStatusRequestWithState:4]];
    [anidb sendRequest:[anime getGroupStatusRequestWithState:6]];
    
    [anidb sendRequest:[ADBRequest createAnimeWithID:anime.id andMask:AM_CHARACTERS]];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Anidb connection delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    NSError *error = nil;
    [anidb save:&error];
    if (error)
        NSLog(@"%@", error);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (void)configureCell:(AnimeTableViewCell *)cell forAnime:(Anime *)anime {
    //[cell.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    if ([anime getFetchedBits:ADBAnimeFetchedAnime]) {
        [cell.animeImage sd_setImageWithURL:[anime getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]]];
        [cell.mainName setText:anime.romajiName];
        [cell.type setText:[NSString stringWithFormat:@"%@, %@ %@", anime.type, anime.numberOfEpisodes, [anime.numberOfEpisodes isEqualToNumber:@1]?@"episode":@"episodes"]];
        [cell.aired setText:[NSString stringWithFormat:@"Aired %@ - %@", [df stringFromDate:anime.airDate], [df stringFromDate:anime.endDate]]];
    } else {
        [cell.animeImage setImage:nil];
        [cell.mainName setText:@"Anime not yet loaded"];
        [cell.type setText:[NSString stringWithFormat:@"Anime ID: %@", anime.id]];
        [cell.aired setText:@""];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return animeController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = animeController.sections;
    return [(id<NSFetchedResultsSectionInfo>)sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AnimeCellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell forAnime:[animeController objectAtIndexPath:indexPath]];
    
    return cell;
}

/*- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static AnimeTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:AnimeCellIdentifier];
    });
    if (tableView == self.tableView)
        [self configureCell:sizingCell forAnime:(Anime *)[self.animeController objectAtIndexPath:indexPath]];
    else
        [self configureCell:sizingCell forAnime:(Anime *)[self.searchResultsController objectAtIndexPath:indexPath]];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}*/

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAnime"]) {
        [((AnimeViewController *)segue.destinationViewController) setRepresentedAnime:[self.animeController objectAtIndexPath:[self.tableView indexPathForSelectedRow]]];
    }
}

@end
