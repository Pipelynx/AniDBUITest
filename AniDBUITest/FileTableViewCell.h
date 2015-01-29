//
//  FileTableViewCell.h
//  AniDBUITest
//
//  Created by Martin Fellner on 29.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *filename;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
