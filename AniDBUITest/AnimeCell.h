//
//  AnimeCell.h
//  AniDBUITest
//
//  Created by Martin Fellner on 17.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *romajiName;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end
