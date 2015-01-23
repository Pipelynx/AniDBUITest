//
//  AnimeBaseController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 22.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeBaseController.h"
#import "Anime.h"
#import "UIImageView+WebCache.h"

@interface AnimeBaseController ()

@end

@implementation AnimeBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AnimeCell" bundle:nil] forCellReuseIdentifier:@"AnimeCell"];
}

- (void)configureCell:(UITableViewCell *)cell forAnime:(Anime *)anime {
    [cell.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    if ([anime.fetched boolValue]) {
        [(UIImageView *)[cell viewWithTag:401] sd_setImageWithURL:[anime getURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]] placeholderImage:[UIImage imageNamed:@"Anime"]];
        [(UILabel *)[cell viewWithTag:402] setText:anime.romajiName];
        [(UILabel *)[cell viewWithTag:403] setText:[NSString stringWithFormat:@"%@, %@ episode%@", anime.type, anime.numberOfEpisodes, [anime.numberOfEpisodes isEqualToNumber:@1]?@"":@"s"]];
        [(UILabel *)[cell viewWithTag:404] setText:[NSString stringWithFormat:@"%@ - %@", [df stringFromDate:anime.airDate], [df stringFromDate:anime.endDate]]];
    }
    else {
        [(UILabel *)[cell viewWithTag:402] setText:@"Anime not yet loaded"];
        [(UILabel *)[cell viewWithTag:403] setText:[NSString stringWithFormat:@"Anime ID: %@", anime.id]];
    }
}

#pragma mark - Table view data source delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
