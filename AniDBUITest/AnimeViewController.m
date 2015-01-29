//
//  AnimeViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeViewController.h"
#import "UIImageView+WebCache.h"
#import "EpisodeTableViewController.h"
#import "GroupTableViewController.h"
#import "CharacterTableViewController.h"
#import "CreatorTableViewController.h"

@interface AnimeViewController ()

@end

@implementation AnimeViewController

@synthesize representedAnime;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    [self.animeImage sd_setImageWithURL:[representedAnime getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]]];
    [self.mainName setText:representedAnime.romajiName];
    [self.secondaryName setText:representedAnime.kanjiName];
    [self.tertiaryName setText:representedAnime.englishName];
    [self.type setText:[NSString stringWithFormat:@"%@, %@ %@", representedAnime.type, representedAnime.numberOfEpisodes, [representedAnime.numberOfEpisodes isEqualToNumber:@1]?@"episode":@"episodes"]];
    [self.aired setText:[NSString stringWithFormat:@"Aired from %@ to %@", [df stringFromDate:representedAnime.airDate], ([representedAnime.endDate timeIntervalSince1970] == 0)?@"today":[df stringFromDate:representedAnime.endDate]]];
    [self.rated setText:[NSString stringWithFormat:@"Rated %.1f out of %@ votes", representedAnime.rating.floatValue / 100, representedAnime.ratingCount]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mainName.preferredMaxLayoutWidth = self.mainName.frame.size.width;
    self.secondaryName.preferredMaxLayoutWidth = self.secondaryName.frame.size.width;
    self.tertiaryName.preferredMaxLayoutWidth = self.tertiaryName.frame.size.width;
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showEpisodes:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showEpisodes" sender:nil]) {
        [self.anidb fetch:representedAnime];
        [self.episodesButton setEnabled:NO];
        [self.episodesActivity startAnimating];
    }
}

- (IBAction)showGroups:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showGroups" sender:nil]) {
        [self.anidb sendRequest:[representedAnime getGroupStatusRequestWithState:ADBGroupStatusOngoingCompleteOrFinished]];
        [self.anidb sendRequest:[representedAnime getGroupStatusRequestWithState:ADBGroupStatusStalled]];
        [self.anidb sendRequest:[representedAnime getGroupStatusRequestWithState:ADBGroupStatusDropped]];
        [self.anidb sendRequest:[representedAnime getGroupStatusRequestWithState:ADBGroupStatusSpecialsOnly]];
        [self.groupsButton setEnabled:NO];
        [self.groupsActivity startAnimating];
    }
}

- (IBAction)showCharacters:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showCharacters" sender:nil]) {
        [self.anidb sendRequest:[representedAnime getCharacterRequest]];
        [self.charactersButton setEnabled:NO];
        [self.charactersActivity startAnimating];
    }
}

- (IBAction)showCreators:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showCreators" sender:nil]) {
        [self.anidb sendRequest:[representedAnime getCreatorRequest]];
        [self.creatorsButton setEnabled:NO];
        [self.creatorsActivity startAnimating];
    }
}

#pragma mark - Anidb delegate

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
    
    if ([self shouldPerformSegueWithIdentifier:@"showEpisodes" sender:nil]) {
        [self.episodesButton setEnabled:YES];
        [self.episodesActivity stopAnimating];
    }
    if ([self shouldPerformSegueWithIdentifier:@"showGroups" sender:nil]) {
        [self.groupsButton setEnabled:YES];
        [self.groupsActivity stopAnimating];
    }
    if ([self shouldPerformSegueWithIdentifier:@"showCharacters" sender:nil]) {
        [self.charactersButton setEnabled:YES];
        [self.charactersActivity stopAnimating];
    }
    if ([self shouldPerformSegueWithIdentifier:@"showCreators" sender:nil]) {
        [self.creatorsButton setEnabled:YES];
        [self.creatorsActivity stopAnimating];
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    BOOL should = YES;
    if ([identifier isEqualToString:@"showEpisodes"]) {
        should = (representedAnime.episodes.count > 0);
    }
    if ([identifier isEqualToString:@"showGroups"]) {
        should = [representedAnime getFetchedBits:ADBAnimeFetchedGroups];
        /*should = should && [representedAnime getFetchedBits:ADBAnimeFetchedOngoingGroups];
        should = should && [representedAnime getFetchedBits:ADBAnimeFetchedStalledGroups];
        should = should && [representedAnime getFetchedBits:ADBAnimeFetchedCompleteGroups];
        should = should && [representedAnime getFetchedBits:ADBAnimeFetchedDroppedGroups];
        should = should && [representedAnime getFetchedBits:ADBAnimeFetchedFinishedGroups];
        should = should && [representedAnime getFetchedBits:ADBAnimeFetchedSpecialsOnlyGroups];*/
    }
    if ([identifier isEqualToString:@"showCharacters"]) {
        should = [representedAnime getFetchedBits:ADBAnimeFetchedCharacters];
    }
    if ([identifier isEqualToString:@"showCreators"]) {
        should = [representedAnime getFetchedBits:ADBAnimeFetchedCreators];
    }
    return should;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEpisodes"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:EpisodeEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"episodeNumber" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", representedAnime.id]];
        [((BaseTableViewController *)segue.destinationViewController) setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"type" cacheName:nil]];
        [((BaseTableViewController *)segue.destinationViewController) setTitle:representedAnime.romajiName];
    }
    if ([segue.identifier isEqualToString:@"showGroups"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:GroupStatusEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"completionState" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"group.name" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", representedAnime.id]];
        [((BaseTableViewController *)segue.destinationViewController) setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"completionState" cacheName:nil]];
        [((BaseTableViewController *)segue.destinationViewController) setTitle:representedAnime.romajiName];
    }
    if ([segue.identifier isEqualToString:@"showCharacters"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CharacterInfoEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"appearanceType" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"character.romajiName" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", representedAnime.id]];
        [((BaseTableViewController *)segue.destinationViewController) setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"appearanceType" cacheName:nil]];
        [((BaseTableViewController *)segue.destinationViewController) setTitle:representedAnime.romajiName];
    }
    if ([segue.identifier isEqualToString:@"showCreators"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CreatorInfoEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"isMainCreator" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"creator.romajiName" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", representedAnime.id]];
        [((BaseTableViewController *)segue.destinationViewController) setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"isMainCreator" cacheName:nil]];
        [((BaseTableViewController *)segue.destinationViewController) setTitle:representedAnime.romajiName];
    }
}

@end
