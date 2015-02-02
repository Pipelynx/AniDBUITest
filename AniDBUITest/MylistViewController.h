//
//  MylistViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 02.02.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface MylistViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *anime;
@property (weak, nonatomic) IBOutlet UILabel *episode;
@property (weak, nonatomic) IBOutlet UILabel *file;
@property (weak, nonatomic) IBOutlet UITextField *source;
@property (weak, nonatomic) IBOutlet UITextField *storage;
@property (weak, nonatomic) IBOutlet UISwitch *viewed;
@property (weak, nonatomic) IBOutlet UITextField *viewDate;
@property (weak, nonatomic) IBOutlet UITextField *state;

@end
