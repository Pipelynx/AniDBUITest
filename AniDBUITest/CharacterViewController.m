//
//  CharacterViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 31.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "CharacterViewController.h"
#import "MWLogging.h"
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
        [[SDWebImageManager sharedManager] downloadImageWithURL:[self.representedCharacter getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (finished) {
                [self.characterImage setImage:image];
            }
            else
                MWLogError(@"%@", error);
        }];
        [self.mainName setText:self.representedCharacter.romajiName];
        [self.secondaryName setText:self.representedCharacter.kanjiName];
        if (self.representedCharacter.typeString)
            [self.type setText:self.representedCharacter.genderString];
        else
            [self.type setText:self.representedCharacter.typeString];
    }
    else {
        [self setTitle:@""];
        [self.mainName setText:@"Character not yet loaded"];
        [self.secondaryName setText:@""];
        [self.type setText:@""];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.characterImage.image) {
        CGSize image = self.characterImage.image.size;
        CGSize view = self.characterImage.frame.size;
        self.characterImageWidth.constant = MIN(image.width, view.width);
        float scale = self.characterImageWidth.constant / image.width;
        if (image.height * scale > self.characterImage.superview.frame.size.height) {
            self.characterImageHeight.constant = self.characterImage.superview.frame.size.height;
            self.characterImageWidth.constant = image.width * (self.characterImageHeight.constant / image.height);
        }
        else {
            self.characterImageHeight.constant = image.height * scale;
        }
    }
    else
        self.characterImageWidth.constant = 0;
    
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
