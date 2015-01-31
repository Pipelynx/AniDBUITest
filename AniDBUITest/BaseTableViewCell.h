//
//  BaseTableViewCell.h
//  AniDBUITest
//
//  Created by Martin Fellner on 31.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_IDENTIFIER @"Cell"

@interface BaseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
