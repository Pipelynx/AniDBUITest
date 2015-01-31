//
//  CharacterViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 31.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface CharacterViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *characterImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *characterImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *characterImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *secondaryName;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end
