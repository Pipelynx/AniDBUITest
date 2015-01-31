//
//  EpisodeViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 29.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "EpisodeViewController.h"
#import "BaseTableViewController.h"

@interface EpisodeViewController ()

@property (nonatomic) Episode *representedEpisode;

@end

@implementation EpisodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)reloadData {
    [super reloadData];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    if ([self.representedEpisode.fetched boolValue]) {
        [self.mainName setText:self.representedEpisode.romajiName];
        [self.secondaryName setText:self.representedEpisode.kanjiName];
        [self.tertiaryName setText:self.representedEpisode.englishName];
        [self.type setText:[NSString stringWithFormat:@"%@ (%@ minutes)", [self translateType:self.representedEpisode.type], self.representedEpisode.length]];
        [self.aired setText:[NSString stringWithFormat:@"Aired on %@", [df stringFromDate:self.representedEpisode.airDate]]];
        if ([self.representedEpisode.ratingCount intValue] > 0) {
            [self.rating setRating:self.representedEpisode.rating.floatValue / 100];
            [self.count setText:[NSString stringWithFormat:@"%@ votes", self.representedEpisode.ratingCount]];
        }
        else {
            [self.rating setRating:0.0f];
            [self.count setText:@"Not rated"];
        }
    }
    else {
        [self.mainName setText:@"Episode not yet loaded"];
        [self.secondaryName setText:@"Please wait for it to load."];
        [self.tertiaryName setText:@""];
        [self.type setText:@""];
        [self.aired setText:@""];
        [self.rating setRating:0.0f];
        [self.count setText:@""];
    }
}

- (NSString *)translateType:(NSNumber *)type {
    switch ([type intValue]) { //1: regular episode (no prefix), 2: special ("S"), 3: credit ("C"), 4: trailer ("T"), 5: parody ("P"), 6: other ("O")
        case 1: return @"Regular episode";
        case 2: return @"Special episode";
        case 3: return @"Credits";
        case 4: return @"Trailer";
        case 5: return @"Parody episode";
        case 6: return @"Other";
        default: return nil;
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

- (IBAction)showFiles:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showFiles" sender:nil]) {
        [self.filesButton setEnabled:NO];
        [self.filesActivity startAnimating];
        for (NSManagedObject *groupStatus in self.representedEpisode.groupStatuses)
            [self.anidb newFileWithAnime:[groupStatus valueForKey:@"anime"] group:[groupStatus valueForKey:@"group"] andEpisode:self.representedEpisode];
        [self saveAnidb];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stopAnimating:) userInfo:nil repeats:NO];
    }
}

- (void)stopAnimating:(NSTimer *)timer {
    [self.filesButton setEnabled:YES];
    [self.filesActivity stopAnimating];
}

#pragma mark - Accessors

- (Episode *)representedEpisode {
    return (Episode *)self.representedObject;
}
- (void)setRepresentedEpisode:(Episode *)episode {
    [self setRepresentedObject:episode];
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showFiles"])
        return (self.representedEpisode.files.count > 0);
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFiles"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:FileEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"group.name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"episode.id == %@", self.representedEpisode.id]];
        [(BaseTableViewController *)segue.destinationViewController setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"group.name" cacheName:nil]];
        [(BaseTableViewController *)segue.destinationViewController setTitle:self.representedEpisode.romajiName];
    }
}

@end
