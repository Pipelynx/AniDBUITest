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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEpisodes"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:EpisodeEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"episodeNumber" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", representedAnime.id]];
        [((EpisodeTableViewController *)segue.destinationViewController) setEpisodeController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"type" cacheName:nil]];
        [((EpisodeTableViewController *)segue.destinationViewController) setTitle:representedAnime.romajiName];
    }
    if ([segue.identifier isEqualToString:@"showGroups"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:GroupStatusEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"completionState" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"group.name" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", representedAnime.id]];
        [((GroupTableViewController *)segue.destinationViewController) setGroupStatusController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"completionState" cacheName:nil]];
        [((GroupTableViewController *)segue.destinationViewController) setTitle:representedAnime.romajiName];
    }
    if ([segue.identifier isEqualToString:@"showCharacters"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CharacterInfoEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"appearanceType" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"character.romajiName" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", representedAnime.id]];
        [((CharacterTableViewController *)segue.destinationViewController) setCharacterInfoController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"appearanceType" cacheName:nil]];
        [((CharacterTableViewController *)segue.destinationViewController) setTitle:representedAnime.romajiName];
    }
}

@end
