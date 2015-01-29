//
//  CharacterTableViewCell.h
//  AniDBUITest
//
//  Created by Martin Fellner on 27.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *characterImage;
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *secondaryName;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
