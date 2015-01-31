//
//  AnimeTableViewCell.h
//  AniDBUITest
//
//  Created by Martin Fellner on 25.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface AnimeTableViewCell : BaseTableViewCell
@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *animeImage;
@property (weak, nonatomic) IBOutlet UILabel *mainName;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *aired;

@end
