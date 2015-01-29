//
//  AnimeViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface AnimeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *animeImage;
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *secondaryName;
@property (weak, nonatomic) IBOutlet UILabel *tertiaryName;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *aired;
@property (weak, nonatomic) IBOutlet UILabel *rated;

@property (weak, nonatomic) IBOutlet UIButton *episodesButton;
@property (weak, nonatomic) IBOutlet UIButton *groupsButton;
@property (weak, nonatomic) IBOutlet UIButton *charactersButton;
@property (weak, nonatomic) IBOutlet UIButton *creatorsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *episodesActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *groupsActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *charactersActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *creatorsActivity;

@property (strong, nonatomic) Anime *representedAnime;

@end
