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

@synthesize characterInfoController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    [characterInfoController performFetch:&error];
    if (error)
        NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(CharacterTableViewCell *)cell forCharacterInfo:(NSManagedObject *)characterInfo {
    Character *character = [characterInfo valueForKey:@"character"];
    NSString *type, *gender;
    if ([character.fetched boolValue]) {
        [cell.characterImage sd_setImageWithURL:[character getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]]];
        [cell.mainName setText:character.romajiName];
        [cell.secondaryName setText:character.kanjiName];
        switch ([character.type intValue]) {
            case 1: type = @"Character"; break;
            case 2: type = @"Mecha"; break;
            case 3: type = @"Organisation"; break;
            case 4: type = @"Vessel"; break;
            default: type = nil; break;
        }
        if (type) {
            gender = @"Unknown";
            if ([character.gender isEqualToString:@"M"])
                gender = @"Male";
            if ([character.gender isEqualToString:@"F"])
                gender = @"Female";
            if ([character.gender isEqualToString:@"I"])
                gender = @"Intersexual";
            if ([character.gender isEqualToString:@"D"])
                gender = @"Dimorphic";
            if ([character.gender isEqualToString:@"-"])
                gender = @"None";
            [cell.type setText:gender];
        }
        else
            [cell.type setText:type];
    }
    else {
        [cell.characterImage setImage:nil];
        [cell.mainName setText:@"Tap to load Character"];
        [cell.secondaryName setText:[NSString stringWithFormat:@"Character ID: %@", character.id]];
        [cell.type setText:@""];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return characterInfoController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch ([[characterInfoController.sections[section] name] intValue]) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [characterInfoController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell forCharacterInfo:[characterInfoController objectAtIndexPath:indexPath]];
    
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
