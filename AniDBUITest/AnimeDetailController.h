//
//  AnimeDetailController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 18.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBPersistentConnection.h"

@interface AnimeDetailController : UIViewController <ADBPersistentConnectionDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Anime *representedObject;
@property (strong, nonatomic) NSFetchedResultsController *episodeController;
@property (strong, nonatomic) ADBPersistentConnection *anidb;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *otherNames;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *aired;
@property (weak, nonatomic) IBOutlet UILabel *rating;



@end
