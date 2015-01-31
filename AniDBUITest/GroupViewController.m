//
//  GroupViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 30.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "GroupViewController.h"
#import "BaseTableViewController.h"

@interface GroupViewController ()

@property (nonatomic) Group *representedGroup;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)reloadData {
    [super reloadData];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    if ([self.representedGroup.fetched boolValue]) {
        if (![self.representedGroup.imageName isEqualToString:@""])
            [self.groupImage sd_setImageWithURL:[self.representedGroup getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                float scale = 1.0f;
                if (error)
                    scale = 0.0f;
                else
                    scale = self.groupImage.frame.size.width / image.size.width;
                self.groupImageHeight.constant = MIN(image.size.height * scale, self.groupImage.superview.frame.size.height / 4);
                [self.groupImage setNeedsDisplay];
            }];
        [self.name setText:[NSString stringWithFormat:@"%@ [%@]", self.representedGroup.name, self.representedGroup.shortName]];
        [self.url setText:self.representedGroup.url];
        [self.irc setText:[self.representedGroup.ircServer isEqualToString:@""]?@"":[NSString stringWithFormat:@"(%@@%@)", self.representedGroup.ircChannel, self.representedGroup.ircServer]];
        [self.lastActivity setText:[NSString stringWithFormat:@"Last activity: %@", [df stringFromDate:self.representedGroup.lastActivity]]];
        [self.counts setText:[NSString stringWithFormat:@"Anime count: %@ File count: %@", self.representedGroup.animeCount, self.representedGroup.fileCount]];
        [self.rating setRating:self.representedGroup.rating.floatValue / 100];
        [self.count setText:[NSString stringWithFormat:@"%@ votes", self.representedGroup.ratingCount]];
    }
    else {
        self.groupImageHeight.constant = 0;
        [self.name setText:@"Group not yet loaded"];
        [self.url setText:@""];
        [self.lastActivity setText:@""];
        [self.counts setText:@""];
        [self.rating setRating:0.0f];
        [self.count setText:@""];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.name.preferredMaxLayoutWidth = self.name.frame.size.width;
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*- (IBAction)showFiles:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showFiles" sender:nil]) {
        [self.filesButton setEnabled:NO];
        [self.filesActivity startAnimating];
        for (Episode *episode in [self.representedObject valueForKey:@"episodes"]) {
            [self.anidb newFileWithAnime:[self.representedObject valueForKey:@"anime"] group:self.representedGroup andEpisode:episode];
        }
        [self saveAnidb];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stopAnimating:) userInfo:nil repeats:NO];
    }
}

- (void)stopAnimating:(NSTimer *)timer {
    [self.filesButton setEnabled:YES];
    [self.filesActivity stopAnimating];
}*/

#pragma mark - Accessors

- (Group *)representedGroup {
    return (Group *)[self.representedObject valueForKey:@"group"];
}
- (void)setRepresentedGroup:(Group *)group {
    @throw [NSException exceptionWithName:@"Can't set group" reason:@"GroupViewController has a GroupStatus object, not a Group object" userInfo:nil];
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showFiles"])
        return (self.representedGroup.files.count > 0);
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFiles"]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:FileEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"episode.type" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"episode.episodeNumber" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"group.id == %@", self.representedGroup.id]];
        [((BaseTableViewController *)segue.destinationViewController) setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ADBPersistentConnection sharedConnection].managedObjectContext sectionNameKeyPath:@"episode.type" cacheName:nil]];
        [((BaseTableViewController *)segue.destinationViewController) setTitle:self.representedGroup.name];
    }
}

@end
