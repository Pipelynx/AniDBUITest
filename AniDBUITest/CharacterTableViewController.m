//
//  CharacterTableViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "CharacterTableViewController.h"
#import "CharacterTableViewCell.h"
#import "UIImageView+WebCache.h"

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

- (void)configureCell:(CharacterTableViewCell *)cell forCharacterInfo:(NSManagedObject *)characterInfo {
    Character *character = [characterInfo valueForKey:@"character"];
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
    NSString *returnType = nil;
    switch ([type intValue]) {
        case 1: returnType = @"Character"; break;
        case 2: returnType = @"Mecha"; break;
        case 3: returnType = @"Organisation"; break;
        case 4: returnType = @"Vessel"; break;
    }
    return returnType;
}

- (NSString *)translateGender:(NSString *)gender {
    NSString *returnGender = @"Unknown";
    if ([gender isEqualToString:@"M"])
        returnGender = @"Male";
    if ([gender isEqualToString:@"F"])
        returnGender = @"Female";
    if ([gender isEqualToString:@"I"])
        returnGender = @"Intersexual";
    if ([gender isEqualToString:@"D"])
        returnGender = @"Dimorphic";
    if ([gender isEqualToString:@"-"])
        returnGender = @"None";
    return returnGender;
}

#pragma mark - Anidb delegate

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [super persistentConnection:connection didReceiveResponse:response];
    NSIndexPath *remove = nil;
    CharacterTableViewCell *cell;
    for (NSIndexPath *indexPath in self.busyIndexPaths) {
        cell = (CharacterTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([[[[self.contentController objectAtIndexPath:indexPath] valueForKey:@"character"] objectID] isEqual:[response objectID]]) {
            [cell.activity stopAnimating];
            remove = indexPath;
        }
        else
            [cell.activity startAnimating];
    }
    if (remove) {
        [self.busyIndexPaths removeObject:remove];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (![self.busyIndexPaths containsObject:indexPath])
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
    CharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forCharacterInfo:[self.contentController objectAtIndexPath:indexPath]];
    
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
