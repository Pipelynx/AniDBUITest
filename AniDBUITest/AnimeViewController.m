//
//  AnimeViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeViewController.h"
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
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Related" style:UIBarButtonItemStylePlain target:self action:@selector(showRelated:)]];
}

- (void)reloadData {
    [super reloadData];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    [self setBackgroundImageWithURL:[self.representedAnime getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]]];
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

- (IBAction)showRelated:(id)sender {
    
}

#pragma mark - Accessors

- (Anime *)representedAnime {
    return (Anime *)self.representedObject;
}
- (void)setRepresentedAnime:(Anime *)anime {
    [self setRepresentedObject:anime];
}

@end
