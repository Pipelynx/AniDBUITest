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

@property (nonatomic) Anime *representedAnime;

@end

@implementation AnimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)reloadData {
    [super reloadData];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    [self setTitle:self.representedAnime.romajiName];
    if (![self.representedAnime.imageName isEqualToString:@""])
        [self.animeImage sd_setImageWithURL:[self.representedAnime getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            float scale = 1.0f;
            if (error)
                scale = 0.0f;
            else
                scale = self.animeImage.frame.size.height / image.size.height;
            self.animeImageWidth.constant = MIN(image.size.width * scale, self.animeImage.superview.frame.size.width / 3);
            [self setBackgroundImage:image];
            [self.animeImage setNeedsDisplay];
        }];
    [self.mainName setText:self.representedAnime.romajiName];
    [self.secondaryName setText:self.representedAnime.kanjiName];
    [self.tertiaryName setText:self.representedAnime.englishName];
    [self.type setText:[NSString stringWithFormat:@"%@, %@ %@", self.representedAnime.type, self.representedAnime.numberOfEpisodes, [self.representedAnime.numberOfEpisodes isEqualToNumber:@1]?@"episode":@"episodes"]];
    [self.aired setText:[NSString stringWithFormat:@"Aired from %@ to %@", [df stringFromDate:self.representedAnime.airDate], ([self.representedAnime.endDate timeIntervalSince1970] == 0)?@"today":[df stringFromDate:self.representedAnime.endDate]]];
    if (self.representedAnime.ratingCount > 0) {
        [self.rating setRating:[self.representedAnime.rating floatValue] / 100];
        [self.count setText:[NSString stringWithFormat:@"%@ votes", self.representedAnime.ratingCount]];
    }
    else {
        [self.rating setRating:[self.representedAnime.tempRating floatValue] / 100];
        [self.count setText:[NSString stringWithFormat:@"%@ votes", self.representedAnime.tempRatingCount]];
    }
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
        [self.anidb fetch:self.representedAnime];
        [self.episodesButton setEnabled:NO];
        [self.episodesActivity startAnimating];
    }
}

- (IBAction)showGroups:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showGroups" sender:nil]) {
        [self.anidb sendRequest:[self.representedAnime getGroupStatusRequestWithState:ADBGroupStatusOngoingCompleteOrFinished]];
        [self.anidb sendRequest:[self.representedAnime getGroupStatusRequestWithState:ADBGroupStatusStalled]];
        [self.anidb sendRequest:[self.representedAnime getGroupStatusRequestWithState:ADBGroupStatusDropped]];
        [self.anidb sendRequest:[self.representedAnime getGroupStatusRequestWithState:ADBGroupStatusSpecialsOnly]];
        [self.groupsButton setEnabled:NO];
        [self.groupsActivity startAnimating];
    }
}

- (IBAction)showCharacters:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showCharacters" sender:nil]) {
        [self.anidb sendRequest:[self.representedAnime getCharacterRequest]];
        [self.charactersButton setEnabled:NO];
        [self.charactersActivity startAnimating];
    }
}

- (IBAction)showCreators:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showCreators" sender:nil]) {
        [self.anidb sendRequest:[self.representedAnime getCreatorRequest]];
        [self.creatorsButton setEnabled:NO];
        [self.creatorsActivity startAnimating];
    }
}

#pragma mark - Accessors

- (Anime *)representedAnime {
    return (Anime *)self.representedObject;
}
- (void)setRepresentedAnime:(Anime *)anime {
    [self setRepresentedObject:anime];
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
    if ([identifier isEqualToString:@"showEpisodes"])
        return (self.representedAnime.episodes.count > 0);
    if ([identifier isEqualToString:@"showGroups"])
        return [self.representedAnime getFetchedBits:ADBAnimeFetchedGroups];
    if ([identifier isEqualToString:@"showCharacters"])
        return [self.representedAnime getFetchedBits:ADBAnimeFetchedCharacters];
    if ([identifier isEqualToString:@"showCreators"])
        return [self.representedAnime getFetchedBits:ADBAnimeFetchedCreators];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEpisodes"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:EpisodeEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"episodeNumber" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", self.representedAnime.id]];
        [((BaseTableViewController *)segue.destinationViewController) setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"type" cacheName:nil]];
        [((BaseTableViewController *)segue.destinationViewController) setTitle:self.representedAnime.romajiName];
    }
    if ([segue.identifier isEqualToString:@"showGroups"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:GroupStatusEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"completionState" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"group.name" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", self.representedAnime.id]];
        [((BaseTableViewController *)segue.destinationViewController) setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"completionState" cacheName:nil]];
        [((BaseTableViewController *)segue.destinationViewController) setTitle:self.representedAnime.romajiName];
    }
    if ([segue.identifier isEqualToString:@"showCharacters"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CharacterInfoEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"appearanceType" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"character.romajiName" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", self.representedAnime.id]];
        [((BaseTableViewController *)segue.destinationViewController) setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"appearanceType" cacheName:nil]];
        [((BaseTableViewController *)segue.destinationViewController) setTitle:self.representedAnime.romajiName];
    }
    if ([segue.identifier isEqualToString:@"showCreators"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CreatorInfoEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"isMainCreator" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"creator.romajiName" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@", self.representedAnime.id]];
        [((BaseTableViewController *)segue.destinationViewController) setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"isMainCreator" cacheName:nil]];
        [((BaseTableViewController *)segue.destinationViewController) setTitle:self.representedAnime.romajiName];
    }
}

@end
