//
//  AnimeTableViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 25.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseTableViewController.h"

@interface AnimeTableViewController : BaseTableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSFetchedResultsController *searchResultsController;

- (void)fetchSearchResultsController;

@end
