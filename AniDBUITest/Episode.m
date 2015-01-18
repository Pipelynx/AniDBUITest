//
//  Episode.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "Episode.h"


@implementation Episode

@dynamic airDate;
@dynamic englishName;
@dynamic id;
@dynamic episodeNumber;
@dynamic fetched;
@dynamic kanjiName;
@dynamic length;
@dynamic rating;
@dynamic ratingCount;
@dynamic romajiName;
@dynamic type;
@dynamic anime;
@dynamic files;
@dynamic mylists;
@dynamic otherFiles;

- (NSString *)getRequest {
    if ([self.id isEqualToNumber:@0])
        return [self getRequestByNumber];
    else
        return [ADBRequest createEpisodeWithID:self.id];
}
- (NSString *)getRequestByNumber {
    return [ADBRequest createEpisodeWithAnimeID:[self.anime valueForKey:@"id"] andEpisodeNumber:[self getEpisodeNumberString]];
}

- (NSString *)getEpisodeNumberString {
    switch ([self.type intValue]) {
        case 2: return [NSString stringWithFormat:@"S%i", [self.episodeNumber intValue]];
        case 3: return [NSString stringWithFormat:@"C%i", [self.episodeNumber intValue]];
        case 4: return [NSString stringWithFormat:@"T%i", [self.episodeNumber intValue]];
        case 5: return [NSString stringWithFormat:@"P%i", [self.episodeNumber intValue]];
        case 6: return [NSString stringWithFormat:@"O%i", [self.episodeNumber intValue]];
        default: return [NSString stringWithFormat:@"%i", [self.episodeNumber intValue]];
    }
}

@end
