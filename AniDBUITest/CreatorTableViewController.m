//
//  CreatorTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "CreatorTableViewController.h"
#import "CreatorTableViewCell.h"

@interface CreatorTableViewController ()

@end

@implementation CreatorTableViewController

@synthesize creatorController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    //[characterInfoController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(CreatorTableViewCell *)cell forCharacterInfo:(NSManagedObject *)characterInfo {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return characterInfoController.sections.count;
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    /*switch ([[characterInfoController.sections[section] name] intValue]) {
        case ADBCharacterAppearanceTypeAppears:
            return @"Appearances";
        case ADBCharacterAppearanceTypeCameoAppearance:
            return @"Cameo appearances";
        case ADBCharacterAppearanceTypeMainCharacter:
            return @"Main Characters";
        case ADBCharacterAppearanceTypeSecondaryCharacter:
            return @"Secondary Characters";
        default:
            return @"Unknown";
    }*/
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [characterInfoController.sections[section] numberOfObjects];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forCharacterInfo:[creatorController objectAtIndexPath:indexPath]];
    
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
