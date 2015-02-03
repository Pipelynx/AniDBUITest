//
//  AnimeViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface AnimeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *secondaryName;
@property (weak, nonatomic) IBOutlet UILabel *tertiaryName;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *aired;
@property (weak, nonatomic) IBOutlet PLRatingView *rating;
@property (weak, nonatomic) IBOutlet UILabel *count;

- (Anime *)representedAnime;
- (void)setRepresentedAnime:(Anime *)anime;

@end
