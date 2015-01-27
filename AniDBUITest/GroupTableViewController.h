//
//  GroupTableViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBPersistentConnection.h"

@interface GroupTableViewController : UITableViewController

@property (strong, nonatomic) NSFetchedResultsController *groupStatusController;

@end
