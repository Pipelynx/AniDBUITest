//
//  Episode.m
//  AniDBUITest
//
//  Created by Martin Fellner on 29.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "DataClasses.h"


@implementation Episode

@dynamic airDate;
@dynamic englishName;
@dynamic episodeNumber;
@dynamic fetched;
@dynamic fetching;
@dynamic id;
@dynamic kanjiName;
@dynamic length;
@dynamic rating;
@dynamic ratingCount;
@dynamic romajiName;
@dynamic type;
@dynamic anime;
@dynamic files;
@dynamic groupStatuses;
@dynamic mylists;
@dynamic otherFiles;

- (NSString *)typeString {
    switch ([self.type intValue]) {
        case 1: return @"Regular episode";
        case 2: return @"Special episode";
        case 3: return @"Credits";
        case 4: return @"Trailer";
        case 5: return @"Parody episode";
        case 6: return @"Other";
        default: return nil;
    }
}

- (NSString *)request {
    if ([self.id isEqualToNumber:@0])
        return [self requestByNumber];
    else
        return [ADBRequest requestEpisodeWithID:self.id];
}

- (NSString *)requestByNumber {
    return [ADBRequest requestEpisodeWithAnimeID:self.anime.id andEpisodeNumber:[self episodeNumberString]];
}

- (NSString *)episodeNumberString {
    switch ([self.type intValue]) {
        case 2: return [NSString stringWithFormat:@"S%02i", [self.episodeNumber intValue]];
        case 3: return [NSString stringWithFormat:@"C%02i", [self.episodeNumber intValue]];
        case 4: return [NSString stringWithFormat:@"T%02i", [self.episodeNumber intValue]];
        case 5: return [NSString stringWithFormat:@"P%02i", [self.episodeNumber intValue]];
        case 6: return [NSString stringWithFormat:@"O%02i", [self.episodeNumber intValue]];
        default: return [NSString stringWithFormat:@"%02i", [self.episodeNumber intValue]];
    }
}

+ (NSNumber *)getTypeFromEpisodeNumberString:(NSString *)episodeNumberString {
    NSString *trimmed = [episodeNumberString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int i = 1;
    if ([trimmed hasPrefix:@"S"])
        i = 2;
    if ([trimmed hasPrefix:@"C"])
        i = 3;
    if ([trimmed hasPrefix:@"T"])
        i = 4;
    if ([trimmed hasPrefix:@"P"])
        i = 5;
    if ([trimmed hasPrefix:@"O"])
        i = 6;
    return [NSNumber numberWithInt:i];
}

+ (NSNumber *)getEpisodeNumberFromEpisodeNumberString:(NSString *)episodeNumberString {
    NSString *trimmed = [episodeNumberString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [NSNumber numberWithLongLong:[[trimmed stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]] longLongValue]];
}

@end
