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
    return [ADBRequest createFileWithID:self.id];
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
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"file.id", self.id, @"episode.id", [(NSManagedObject *)episode valueForKey:@"id"]]];
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
