//
//  FileViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 01.02.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface FileViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *fileDescription;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *crc32;
@property (weak, nonatomic) IBOutlet UILabel *ed2k;
@property (weak, nonatomic) IBOutlet UILabel *md5;
@property (weak, nonatomic) IBOutlet UILabel *sha1;
@property (weak, nonatomic) IBOutlet UILabel *video;
@property (weak, nonatomic) IBOutlet UILabel *audio;
@property (weak, nonatomic) IBOutlet UILabel *subtitles;

@end
