//
//  CreatorViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 03.02.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface CreatorViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *creatorImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creatorImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *creatorImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *secondaryName;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end
