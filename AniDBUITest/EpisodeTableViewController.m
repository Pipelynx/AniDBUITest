//
//  EpisodeTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "EpisodeTableViewController.h"
#import "EpisodeTableViewCell.h"

@interface EpisodeTableViewController ()

@end

@implementation EpisodeTableViewController

@synthesize episodeController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    [episodeController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(EpisodeTableViewCell *)cell forEpisode:(Episode *)episode {
    [cell.episodeNumber setText:[episode getEpisodeNumberString]];
    [cell.mainName setText:episode.romajiName];
    [cell.secondaryName setText:episode.kanjiName];
    [cell.tertiaryName setText:episode.englishName];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return episodeController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ([[episodeController.sections[section] name] intValue]) {
        case ADBEpisodeTypeCredits:
            return @"Credits";
        case ADBEpisodeTypeSpecial:
            return @"Specials";
        case ADBEpisodeTypeTrailer:
            return @"Trailers";
        case ADBEpisodeTypeParody:
            return @"Parodies";
        case ADBEpisodeTypeOther:
            return @"Others";
        case ADBEpisodeTypeNormal:
            return @"Episodes";
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [episodeController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forEpisode:[episodeController objectAtIndexPath:indexPath]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
