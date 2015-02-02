//
//  EpisodeViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 29.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface EpisodeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *secondaryName;
@property (weak, nonatomic) IBOutlet UILabel *tertiaryName;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *aired;
@property (weak, nonatomic) IBOutlet PLRatingView *rating;
@property (weak, nonatomic) IBOutlet UILabel *count;

@property (weak, nonatomic) IBOutlet UIButton *filesButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *filesActivity;

- (Episode *)representedEpisode;
- (void)setRepresentedEpisode:(Episode *)episode;

@end
