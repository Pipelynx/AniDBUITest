//
//  CharacterViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 31.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "CharacterViewController.h"
#import "BaseTableViewController.h"

@interface CharacterViewController ()

@property (nonatomic) Character *representedCharacter;

@end

@implementation CharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)reloadData {
    [super reloadData];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    if ([self.representedCharacter.fetched boolValue]) {
        [self setTitle:self.representedCharacter.romajiName];
        if (![self.representedCharacter.imageName isEqualToString:@""])
            [self.characterImage sd_setImageWithURL:[self.representedCharacter getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                float scale = 1.0f;
                if (error)
                    scale = 0.0f;
                else
                    scale = self.characterImage.bounds.size.width / image.size.width;
                self.characterImageWidth.constant = MIN(image.size.width * scale, self.characterImage.superview.bounds.size.width / 3);
                scale = self.characterImageWidth.constant / image.size.width;
                self.characterImageHeight.constant = image.size.height * scale;
                [self.characterImage setNeedsDisplay];
            }];
        [self.mainName setText:self.representedCharacter.romajiName];
        [self.secondaryName setText:self.representedCharacter.kanjiName];
        if ([self translateType:self.representedCharacter.type])
            [self.type setText:[self translateGender:self.representedCharacter.gender]];
        else
            [self.type setText:[self translateType:self.representedCharacter.type]];
    }
    else {
        self.characterImageWidth.constant = 0;
        [self setTitle:@""];
        [self.mainName setText:@"Character not yet loaded"];
        [self.secondaryName setText:@""];
        [self.type setText:@""];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mainName.preferredMaxLayoutWidth = self.mainName.frame.size.width;
    self.secondaryName.preferredMaxLayoutWidth = self.secondaryName.frame.size.width;
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (Character *)representedCharacter {
    return (Character *)[self.representedObject valueForKey:@"character"];
}
- (void)setRepresentedCharacter:(Character *)character {
    @throw [NSException exceptionWithName:@"Can't set character" reason:@"CharacterViewController has a CharacterInfo object, not a Character object" userInfo:nil];
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
