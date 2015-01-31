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
        if ([self translateType:character.type])
            [cell.type setText:[self translateGender:character.gender]];
        else
            [cell.type setText:[self translateType:character.type]];
    }
    else {
        [cell.characterImage setImage:nil];
        [cell.mainName setText:@"Tap to load Character"];
        [cell.secondaryName setText:[NSString stringWithFormat:@"Character ID: %@", character.id]];
        [cell.type setText:@""];
    }
}

- (NSString *)translateType:(NSNumber *)type {
    switch ([type intValue]) {
        case 1: return @"Character";
        case 2: return @"Mecha";
        case 3: return @"Organisation";
        case 4: return @"Vessel";
        default: return nil;
    }
}

- (NSString *)translateGender:(NSString *)gender {
    if ([gender isEqualToString:@"M"])
        return @"Male";
    if ([gender isEqualToString:@"F"])
        return @"Female";
    if ([gender isEqualToString:@"I"])
        return @"Intersexual";
    if ([gender isEqualToString:@"D"])
        return @"Dimorphic";
    if ([gender isEqualToString:@"-"])
        return @"None";
    return @"Unknown";
}

- (BOOL)indexPath:(NSIndexPath *)indexPath hasManagedObject:(NSManagedObject *)object {
    return [[[[self.contentController objectAtIndexPath:indexPath] valueForKey:@"character"] objectID] isEqual:[object objectID]];
}

#pragma mark - Anidb delegate

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (![[(Character *)[[self.contentController objectAtIndexPath:indexPath] valueForKey:@"character"] fetched] boolValue])
        [((CharacterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).activity startAnimating];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showCharacter"]) {
        return [[(Character *)[[self.contentController objectAtIndexPath:[self.tableView indexPathForCell:sender]] valueForKey:@"character"] fetched] boolValue];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCharacter"]) {
        NSManagedObject *characterInfo = [self.contentController objectAtIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)sender]];
        [segue.destinationViewController setTitle:[[characterInfo valueForKey:@"character"] valueForKey:@"romajiName"]];
        [(BaseViewController *)segue.destinationViewController setRepresentedObject:characterInfo];
    }
}

@end
