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
        [self.groupImage sd_setImageWithURL:[self.representedGroup getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            float scale = self.groupImage.frame.size.width / image.size.width;
            self.groupImageHeight.constant = MIN(image.size.height * scale, self.groupImage.superview.frame.size.height / 2);
            [self.groupImage setNeedsDisplay];
        }];
        [self.name setText:[NSString stringWithFormat:@"%@ [%@]", self.representedGroup.name, self.representedGroup.shortName]];
        [self.url setText:[NSString stringWithFormat:@"%@ (%@@%@)", self.representedGroup.url, self.representedGroup.ircChannel, self.representedGroup.ircServer]];
        [self.lastActivity setText:[NSString stringWithFormat:@"Last activity: %@", [df stringFromDate:self.representedGroup.lastActivity]]];
        [self.counts setText:[NSString stringWithFormat:@"Anime count: %@ File count: %@", self.representedGroup.animeCount, self.representedGroup.fileCount]];
        [self.rating setText:[NSString stringWithFormat:@"Rated %.1f out of %@ votes", self.representedGroup.rating.floatValue / 100, self.representedGroup.ratingCount]];
    }
    else {
        [self.groupImage setImage:nil];
        self.groupImageHeight.constant = 0;
        [self.groupImage setNeedsDisplay];
        [self.name setText:@"Group not yet loaded"];
        [self.url setText:@""];
        [self.lastActivity setText:@""];
        [self.counts setText:@""];
        [self.rating setText:@""];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showFiles:(id)sender {
    if (![self shouldPerformSegueWithIdentifier:@"showFiles" sender:nil]) {
        [self.filesButton setEnabled:NO];
        [self.filesActivity startAnimating];
        for (NSManagedObject *groupStatus in self.representedGroup.groupStatuses)
            for (Episode *episode in [groupStatus valueForKey:@"episodes"]) {
                [self.anidb newFileWithAnime:[groupStatus valueForKey:@"anime"] group:self.representedGroup andEpisode:episode];
            }
        [self saveAnidb];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stopAnimating:) userInfo:nil repeats:NO];
    }
}

- (void)stopAnimating:(NSTimer *)timer {
    [self.filesButton setEnabled:YES];
    [self.filesActivity stopAnimating];
}

#pragma mark - Accessors

- (Group *)representedGroup {
    return (Group *)self.representedObject;
}
- (void)setRepresentedGroup:(Group *)group {
    [self setRepresentedObject:group];
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
