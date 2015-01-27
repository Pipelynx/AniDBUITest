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

@property (strong, nonatomic) Anime *representedAnime;

@end
