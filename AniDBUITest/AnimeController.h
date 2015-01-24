//
//  AnimeController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 16.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeBaseController.h"
#import "ADBPersistentConnection.h"

@class AnimeCell;

@interface AnimeController : AnimeBaseController <ADBPersistentConnectionDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ADBPersistentConnection *anidb;
@property (strong, nonatomic) NSFetchedResultsController *searchController;

@end
