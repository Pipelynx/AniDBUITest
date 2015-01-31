//
//  GroupViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 30.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface GroupViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupImageHeight;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *url;
@property (weak, nonatomic) IBOutlet UILabel *irc;
@property (weak, nonatomic) IBOutlet UILabel *lastActivity;
@property (weak, nonatomic) IBOutlet UILabel *counts;
@property (weak, nonatomic) IBOutlet PLRatingView *rating;
@property (weak, nonatomic) IBOutlet UILabel *count;

@end
