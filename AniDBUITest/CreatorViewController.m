//
//  CreatorViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 03.02.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "CreatorViewController.h"
#import "MWLogging.h"

@interface CreatorViewController ()

@property (strong, nonatomic) Creator *representedCreator;

@end

@implementation CreatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)reloadData {
    [super reloadData];
    
    if ([self.representedCreator.fetched boolValue]) {
        [self setTitle:self.representedCreator.romajiName];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[self.representedCreator getImageURLWithServer:[[NSUserDefaults standardUserDefaults] URLForKey:@"imageServer"]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (finished) {
                [self.creatorImage setImage:image];
            }
            else
                MWLogError(@"%@", error);
        }];
        [self.mainName setText:self.representedCreator.romajiName];
        [self.secondaryName setText:self.representedCreator.kanjiName];
        [self.type setText:self.representedCreator.typeString];
    }
    else {
        [self setTitle:@""];
        [self.mainName setText:@"Creator not yet loaded"];
        [self.secondaryName setText:@""];
        [self.type setText:@""];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.creatorImage.image) {
        CGSize image = self.creatorImage.image.size;
        CGSize view = self.creatorImage.frame.size;
        self.creatorImageWidth.constant = MIN(image.width, view.width);
        float scale = self.creatorImageWidth.constant / image.width;
        if (image.height * scale > self.creatorImage.superview.frame.size.height) {
            self.creatorImageHeight.constant = self.creatorImage.superview.frame.size.height;
            self.creatorImageWidth.constant = image.width * (self.creatorImageHeight.constant / image.height);
        }
        else {
            self.creatorImageHeight.constant = image.height * scale;
        }
    }
    else
        self.creatorImageWidth.constant = 0;
    
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (Creator *)representedCreator {
    return (Creator *)[self.representedObject valueForKey:@"creator"];
}
- (void)setRepresentedCharacter:(Character *)character {
    @throw [NSException exceptionWithName:@"Can't set creator" reason:@"CreatorViewController has a CreatorInfo object, not a Creator object" userInfo:nil];
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
