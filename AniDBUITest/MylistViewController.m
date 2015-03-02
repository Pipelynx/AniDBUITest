//
//  MylistViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 02.02.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "MylistViewController.h"

@interface MylistViewController ()

@property (nonatomic) File *representedFile;

@end

@implementation MylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(mylistSave:)]];
}

- (void)reloadData {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    if ([self.representedFile.fetched boolValue]) {
        [self.anime setText:self.representedFile.anime.romajiName];
        [self.episode setText:[NSString stringWithFormat:@"Episode %@", [self.representedFile.episode episodeNumberString]]];
        [self.file setText:[NSString stringWithFormat:@"%@, %@, f%@", self.representedFile.group.name, [self.representedFile binarySizeString], self.representedFile.id]];
    }
    else {
        [self.anime setText:@"File not yet loaded"];
        [self.episode setText:@""];
        [self.file setText:@""];
    }
    
    [self.anidb newMylistWithFile:self.representedFile andFetch:YES];
    if ([self.representedFile.mylist.fetched boolValue]) {
        [self enableTextFields:YES];
        [self.source setText:self.representedFile.mylist.source];
        [self.storage setText:self.representedFile.mylist.storage];
        if ([self.representedFile.mylist.viewDate timeIntervalSince1970] != 0) {
            [self.viewed setOn:YES];
            [self.viewDate setEnabled:YES];
            [self.viewDate setText:[df stringFromDate:self.representedFile.mylist.viewDate]];
        }
        else {
            [self.viewed setOn:NO];
            [self.viewDate setEnabled:NO];
            [self.viewDate setText:@"Not viewed"];
        }
        [self.state setText:self.representedFile.mylist.stateString];
    }
    else {
        [self.source setText:@""];
        [self.storage setText:@""];
        [self.viewed setOn:NO];
        [self.viewDate setEnabled:NO];
        [self.viewDate setText:@"Not viewed"];
        [self.state setText:@"Unknown"];
    }
}

- (void)enableTextFields:(BOOL)enable {
    [self.source setEnabled:enable];
    [self.storage setEnabled:enable];
    [self.viewed setEnabled:enable];
    [self.viewDate setEnabled:enable];
    [self.state setEnabled:enable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)mylistSave:(id)sender {
    ADBMylistState state = 0;
    BOOL viewed = NO;
    NSDate *viewDate = nil;
    NSString *source = nil;
    NSString *storage = nil;
    NSString *other = nil;
    
    [self.anidb sendRequest:[ADBRequest requestMylistAddWithFileID:self.representedFile.id andParameters:[ADBRequest parameterDictionaryWithState:state viewed:viewed viewDate:viewDate source:source storage:storage andOther:other]]];
}

#pragma mark - Accessors

- (File *)representedFile {
    return (File *)self.representedObject;
}
- (void)setRepresentedFile:(File *)file {
    [self setRepresentedObject:file];
}

@end
