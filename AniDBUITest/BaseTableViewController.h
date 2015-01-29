//
//  BaseTableViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBPersistentConnection.h"
#import "UIImageView+WebCache.h"

@interface BaseTableViewController : UITableViewController <ADBPersistentConnectionDelegate>

@property (weak, nonatomic) ADBPersistentConnection *anidb;
@property (strong, nonatomic) NSFetchedResultsController *contentController;
@property (strong, nonatomic) NSMutableSet *busyIndexPaths;

@end
