//
//  AnimeViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBPersistentConnection.h"

@interface AnimeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *animeImage;
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *secondaryName;
@property (weak, nonatomic) IBOutlet UILabel *tertiaryName;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *aired;
@property (weak, nonatomic) IBOutlet UILabel *rated;

@property (strong, nonatomic) Anime *representedAnime;

@end
