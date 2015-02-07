//
//  CharacterTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "CharacterTableViewController.h"
#import "CharacterTableViewCell.h"
#import "BaseViewController.h"

@interface CharacterTableViewController ()

@end

@implementation CharacterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(CharacterTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell forIndexPath:indexPath];
    Character *character = [[self.contentController objectAtIndexPath:indexPath] valueForKey:@"character"];
    if ([character.fetched boolValue]) {
        [cell.characterImage sd_setImageWithURL:[character getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]]];
        [cell.mainName setText:character.romajiName];
        [cell.secondaryName setText:character.kanjiName];
        if (character.typeString)
            [cell.type setText:character.genderString];
        else
            [cell.type setText:character.typeString];
    }
    else {
        [cell.characterImage setImage:nil];
        [cell.mainName setText:@"Tap to load Character"];
        [cell.secondaryName setText:[NSString stringWithFormat:@"Character ID: %@", character.id]];
        [cell.type setText:@""];
    }
}

- (BOOL)indexPath:(NSIndexPath *)indexPath hasManagedObject:(NSManagedObject *)object {
    return [[[[self.contentController objectAtIndexPath:indexPath] valueForKey:@"character"] objectID] isEqual:[object objectID]];
}

#pragma mark - Anidb delegate

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ([[self.contentController.sections[section] name] intValue]) {
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
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCharacter"]) {
        NSManagedObject *characterInfo = [self.contentController objectAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)sender]];
        [(BaseViewController *)segue.destinationViewController setRepresentedObject:characterInfo];
    }
}

@end
