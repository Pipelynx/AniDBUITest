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

@class BaseTableViewCell;

@interface BaseTableViewController : UITableViewController <ADBPersistentConnectionDelegate>

@property (weak, nonatomic) ADBPersistentConnection *anidb;
@property (strong, nonatomic) NSFetchedResultsController *contentController;
@property (strong, nonatomic) NSManagedObject *representedObject;

- (void)saveAnidb;

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (BOOL)indexPath:(NSIndexPath *)indexPath hasManagedObject:(NSManagedObject *)object;

@end
