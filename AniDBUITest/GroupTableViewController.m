//
//  GroupTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "GroupTableViewController.h"
#import "GroupTableViewCell.h"


@interface GroupTableViewController ()

@end

@implementation GroupTableViewController

@synthesize groupStatusController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    [groupStatusController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(GroupTableViewCell *)cell forGroupStatus:(NSManagedObject *)groupStatus {
    Group *group = [groupStatus valueForKey:@"group"];
    [cell.name setText:[NSString stringWithFormat:@"%@ [%@]", group.name, group.shortName]];
    [cell.rating setText:[NSString stringWithFormat:@"Rated %.1f out of %@ votes", group.rating.floatValue / 100, group.ratingCount]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return groupStatusController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ([[groupStatusController.sections[section] name] intValue]) {
        case ADBGroupStatusOngoing:
            return @"Ongoing";
        case ADBGroupStatusStalled:
            return @"Stalled";
        case ADBGroupStatusComplete:
            return @"Complete";
        case ADBGroupStatusDropped:
            return @"Dropped";
        case ADBGroupStatusFinished:
            return @"Finished";
        case ADBGroupStatusSpecialsOnly:
            return @"Specials only";
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [groupStatusController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forGroupStatus:[groupStatusController objectAtIndexPath:indexPath]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
