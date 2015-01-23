//
//  AnimeBaseController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 22.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Anime;

@interface AnimeBaseController : UITableViewController

@property (strong, nonatomic) NSFetchedResultsController *animeController;

- (void)configureCell:(UITableViewCell *)cell forAnime:(Anime *)anime;

@end
