//
//  FileViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 01.02.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "FileViewController.h"

@interface FileViewController ()

@property (nonatomic) File *representedFile;

@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Mylist" style:UIBarButtonItemStylePlain target:self action:@selector(mylistAdd:)]];
}

- (void)reloadData {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    
    [self setTitle:[NSString stringWithFormat:@"File %@", self.representedFile.id]];
    
    [self.fileDescription setText:[NSString stringWithFormat:@"%@ - %@ released by %@ on %@ %@", self.representedFile.anime.romajiName, [self.representedFile.episode episodeNumberString], self.representedFile.group.name, [df stringFromDate:self.representedFile.airDate], self.representedFile.matchesOfficialCRC?@"matches official CRC":@"does not match official CRC"]];
    [self.source setText:[NSString stringWithFormat:@"Source: %@, %@ quality, v%i", self.representedFile.source, self.representedFile.quality, self.representedFile.version]];
    
    [df setDateFormat:@"mm:ss"];
    [self.size setText:[NSString stringWithFormat:@"Size: %@, %@", [self.representedFile binarySizeString], [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.representedFile.length unsignedIntegerValue]]]]];
    [self.crc32 setText:self.representedFile.crc32];
    [self.ed2k setText:self.representedFile.ed2k];
    [self.md5 setText:self.representedFile.md5];
    [self.sha1 setText:self.representedFile.sha1];
    [self.video setText:[self.representedFile longVideoString]];
    [self.audio setText:[self.representedFile longDubsString]];
    [self.subtitles setText:[self.representedFile longSubsString]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.fileDescription.preferredMaxLayoutWidth = self.fileDescription.frame.size.width;
    self.audio.preferredMaxLayoutWidth = self.audio.frame.size.width;
    self.subtitles.preferredMaxLayoutWidth = self.subtitles.frame.size.width;
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mylistAdd:(id)sender {
    [self performSegueWithIdentifier:@"showMylist" sender:sender];
}

#pragma mark - Accessors

- (File *)representedFile {
    return (File *)self.representedObject;
}
- (void)setRepresentedFile:(File *)file {
    [self setRepresentedObject:file];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMylist"]) {
        [(BaseViewController *)segue.destinationViewController setRepresentedObject:self.representedFile];
    }
}

@end
