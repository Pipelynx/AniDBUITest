//
//  BaseTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableViewCell.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

@synthesize anidb;
@synthesize contentController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.busyIndexPaths = [NSMutableSet set];
    
    anidb = [ADBPersistentConnection sharedConnection];
    [anidb addDelegate:self];
    
    [self fetchContentController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveAnidb {
    NSError *error = nil;
    [anidb save:&error];
    if (error)
        NSLog(@"%@", error);
}

- (void)fetchContentController {
    NSError *error = nil;
    [contentController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
}

- (void)configureCell:(BaseTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    if ([self.busyIndexPaths containsObject:indexPath])
        [cell.activity startAnimating];
    else
        [cell.activity stopAnimating];
}

- (BOOL)indexPath:(NSIndexPath *)indexPath hasManagedObject:(NSManagedObject *)object {
    return [[[self.contentController objectAtIndexPath:indexPath] objectID] isEqual:[object objectID]];
}

#pragma mark - Anidb connection delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    [self saveAnidb];
    [self fetchContentController];
    
    if ([response[@"responseType"] intValue] == ADBResponseCodeMultipleFilesFound) {
        NSIndexPath *remove = nil;
        for (NSIndexPath *indexPath in self.busyIndexPaths)
            for (NSString *fileID in response[@"fileIDs"])
                if ([[(File *)[self.contentController objectAtIndexPath:indexPath] id] isEqualToNumber:[NSNumber numberWithString:fileID]]) {
                    remove = indexPath;
                    break;
                }
        if (remove)
            [self.busyIndexPaths removeObject:remove];
    }
    
    [self.tableView reloadData];
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [self saveAnidb];
    [self fetchContentController];
    
    NSIndexPath *remove = nil;
    for (NSIndexPath *indexPath in self.busyIndexPaths) {
        if ([self indexPath:indexPath hasManagedObject:response]) {
            remove = indexPath;
            break;
        }
    }
    if (remove)
        [self.busyIndexPaths removeObject:remove];
        
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.busyIndexPaths containsObject:indexPath]) {
        [self.anidb fetch:[self.contentController objectAtIndexPath:indexPath]];
        [self.busyIndexPaths addObject:indexPath];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contentController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contentController.sections[section] numberOfObjects];
}

@end
