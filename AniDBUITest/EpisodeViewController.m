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
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Files" style:UIBarButtonItemStylePlain target:self action:@selector(showFiles:)]];
}

- (void)reloadData {
    [super reloadData];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    if ([self.representedEpisode.fetched boolValue]) {
        [self setTitle:[NSString stringWithFormat:@"Episode %@", [self.representedEpisode episodeNumberString]]];
        [self.mainName setText:self.representedEpisode.romajiName];
        [self.secondaryName setText:self.representedEpisode.kanjiName];
        [self.tertiaryName setText:self.representedEpisode.englishName];
        [self.type setText:[NSString stringWithFormat:@"%@ (%@ minutes)", self.representedEpisode.typeString, self.representedEpisode.length]];
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
        [self setTitle:@""];
        [self.mainName setText:@"Episode not yet loaded"];
        [self.secondaryName setText:@"Please wait for it to load."];
        [self.tertiaryName setText:@""];
        [self.type setText:@""];
        [self.aired setText:@""];
        [self.rating setRating:0.0f];
        [self.count setText:@""];
    }
}

- (void)viewDidLayoutSubviews {
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
    [self performSegueWithIdentifier:@"showFiles" sender:self.navigationItem.rightBarButtonItem];
}

#pragma mark - Accessors

- (Episode *)representedEpisode {
    return (Episode *)self.representedObject;
}
- (void)setRepresentedEpisode:(Episode *)episode {
    [self setRepresentedObject:episode];
}

#pragma mark - Anidb delegate

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFiles"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:FileEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"group.name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"episode.id == %@", self.representedEpisode.id]];
        [(BaseTableViewController *)segue.destinationViewController setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"group.name" cacheName:nil]];
    }
}

@end
