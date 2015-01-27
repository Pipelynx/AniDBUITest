//
//  AnimeTableViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 25.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBPersistentConnection.h"

@interface AnimeTableViewController : UITableViewController <ADBPersistentConnectionDelegate>

@property (strong, nonatomic) NSFetchedResultsController *animeController;
@property (strong, nonatomic) NSFetchedResultsController *searchResultsController;

@end
