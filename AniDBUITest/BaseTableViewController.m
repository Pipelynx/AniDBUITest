//
//  BaseTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseTableViewController.h"

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
    
    NSError *error = nil;
    [contentController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Anidb connection delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    NSError *error = nil;
    [anidb save:&error];
    if (error)
        NSLog(@"%@", error);
    error = nil;
    [contentController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
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
