//
//  File.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "DataClasses.h"


@implementation File

@dynamic id;
@dynamic fetched;
@dynamic fetching;
@dynamic isDeprecated;
@dynamic state;
@dynamic size;
@dynamic ed2k;
@dynamic md5;
@dynamic sha1;
@dynamic crc32;
@dynamic quality;
@dynamic source;
@dynamic fileExtension;
@dynamic length;
@dynamic fileDescription;
@dynamic airDate;
@dynamic aniDBFilename;
@dynamic anime;
@dynamic episode;
@dynamic group;
@dynamic mylist;
@dynamic otherEpisodes;
@dynamic audio;
@dynamic video;
@dynamic dubs;
@dynamic subs;

- (NSString *)getRequest {
    if ([self.id isEqualToNumber:@0])
        return [self getRequestByAnimeGroupAndEpisode];
    else
        return [ADBRequest requestFileWithID:self.id];
}

- (NSString *)getRequestByAnimeGroupAndEpisode {
    return [ADBRequest requestFileWithAnimeID:self.anime.id groupID:self.group.id andEpisodeNumber:[self.episode getEpisodeNumberString]];
}

- (NSString *)binarySizeString {
    return [self sizeStringWithStep:1024 andUnits:@[ @"B", @"KB", @"MB", @"GB" ]];
}

- (NSString *)SISizeString {
    return [self sizeStringWithStep:1000 andUnits:@[ @"B", @"KiB", @"MiB", @"GiB" ]];
}

- (NSString *)sizeStringWithStep:(unsigned int)step andUnits:(NSArray *)units {
    double size = [self.size doubleValue];
    if ((size / step) < 1)
        return [NSString stringWithFormat:@"%.0f %@", size, units[0]];
    if ((size / (step * step)) < 1)
        return [NSString stringWithFormat:@"%.0f %@", size / step, units[1]];
    if ((size / (step * step * step)) < 1)
        return [NSString stringWithFormat:@"%.1f %@", size / (step * step), units[2]];
    return [NSString stringWithFormat:@"%.2f %@\n", size / (step * step * step), units[3]];
}

- (NSString *)shortVideoString {
    return [NSString stringWithFormat:@"V:%@ %@", [self.video valueForKey:@"codec"], [self.video valueForKey:@"resolution"]];
}

- (NSString *)longVideoString {
    return [NSString stringWithFormat:@"Video: %@ %@ @ %@kbit/s %@bit", [self.video valueForKey:@"resolution"], [self.video valueForKey:@"codec"], [self.video valueForKey:@"bitrate"], [self.video valueForKey:@"colourDepth"]];
}

- (NSString *)shortDubsString {
    NSMutableString *temp = [NSMutableString string];
    int i = 1;
    for (NSManagedObject *stream in self.dubs) {
        [temp appendFormat:@"A%i:%@ ", i, [self abbreviateLanguage:[stream valueForKey:@"language"]]];
        i++;
    }
    return [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)longDubsString {
    NSMutableString *temp = [NSMutableString string];
    int i = 1;
    for (NSManagedObject *stream in self.dubs) {
        [temp appendFormat:@"Audio %i: %@\n", i, [stream valueForKey:@"language"]];
        i++;
    }
    return [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)shortSubsString {
    NSMutableString *temp = [NSMutableString string];
    int i = 1;
    for (NSManagedObject *stream in self.subs) {
        [temp appendFormat:@"S%i:%@ ", i, [self abbreviateLanguage:[stream valueForKey:@"language"]]];
        i++;
    }
    return [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)longSubsString {
    NSMutableString *temp = [NSMutableString string];
    int i = 1;
    for (NSManagedObject *stream in self.subs) {
        [temp appendFormat:@"Subtitle %i: %@\n", i, [stream valueForKey:@"language"]];
        i++;
    }
    return [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)abbreviateLanguage:(NSString *)language {
    NSDictionary *languages = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"languages" ofType:@"plist"]];
    if (languages[language])
        return languages[language];
    else
        return language;
}

- (BOOL)matchesOfficialCRC {
    return (self.state.intValue & ADBFileStateCRCOK);
}

- (unsigned short)version {
    if (self.state.intValue & ADBFileStateVersion2)
        return 2;
    if (self.state.intValue & ADBFileStateVersion3)
        return 3;
    if (self.state.intValue & ADBFileStateVersion4)
        return 4;
    if (self.state.intValue & ADBFileStateVersion5)
        return 5;
    return 1;
}

- (BOOL)isCensored {
    return (self.state.intValue & ADBFileStateCensored);
}

- (void)setVideoWithCodec:(NSString *)codec bitrate:(NSNumber *)bitrate resolution:(NSString *)resolution andColourDepth:(NSString *)colourDepth {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:VideoEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@ AND %K == %@", @"codec", codec, @"bitrate", bitrate, @"resolution", resolution]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = result[0];
        else {
            temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:VideoEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:codec forKey:@"codec"];
            [temp setValue:bitrate forKey:@"bitrate"];
            [temp setValue:resolution forKey:@"resolution"];
            [temp setValue:colourDepth forKey:@"colourDepth"];
        }
        [self setVideo:temp];
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
}

- (void)addAudioWithCodec:(NSString *)codec andBitrate:(NSNumber *)bitrate {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:AudioEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"codec", codec, @"bitrate", bitrate]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = result[0];
        else {
            temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:AudioEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:codec forKey:@"codec"];
            [temp setValue:bitrate forKey:@"bitrate"];
        }
        [self addAudioObject:temp];
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
}

- (NSManagedObject *)getStreamWithLanguage:(NSString *)language {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:StreamEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"language", language]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = result[0];
        else {
            temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:StreamEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:language forKey:@"language"];
        }
        return temp;
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    return nil;
}

- (void)addSubsWithLanguage:(NSString *)language {
    [self addSubsObject:[self getStreamWithLanguage:language]];
}

- (void)addDubsWithLanguage:(NSString *)language {
    [self addDubsObject:[self getStreamWithLanguage:language]];
}

- (NSManagedObject *)addOtherEpisodeWithEpisode:(Episode *)episode andPercentage:(NSNumber *)percentage {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:OtherEpisodeEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"file.id", self.id, @"episode.id", episode.id]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = result[0];
        else {
            temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:OtherEpisodeEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:episode forKey:@"episode"];
            [self addOtherEpisodesObject:temp];
        }
        [temp setValue:percentage forKey:@"percentage"];
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    return temp;
}

@end
