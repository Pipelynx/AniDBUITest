//
//  File.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Anime, Episode, Group, Mylist;


@interface File : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * fetched;
@property (nonatomic, retain) NSNumber * isDeprecated;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * ed2k;
@property (nonatomic, retain) NSString * md5;
@property (nonatomic, retain) NSString * sha1;
@property (nonatomic, retain) NSString * crc32;
@property (nonatomic, retain) NSString * quality;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * fileExtension;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSString * fileDescription;
@property (nonatomic, retain) NSDate * airDate;
@property (nonatomic, retain) NSString * aniDBFilename;
@property (nonatomic, retain) Anime *anime;
@property (nonatomic, retain) Episode *episode;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) Mylist *mylist;
@property (nonatomic, retain) NSSet *otherEpisodes;
@property (nonatomic, retain) NSSet *audio;
@property (nonatomic, retain) NSManagedObject *video;
@property (nonatomic, retain) NSSet *dubs;
@property (nonatomic, retain) NSSet *subs;

- (NSString *)getRequest;
- (NSString *)getRequestByAnimeGroupAndEpisode;

- (NSString *)getBinarySizeString;
- (NSString *)getSISizeString;

- (NSString *)getVideoString;
- (NSString *)getDubsString;
- (NSString *)getSubsString;

- (NSString *)abbreviateLanguage:(NSString *)language;

- (void)setVideoWithCodec:(NSString *)codec bitrate:(NSNumber *)bitrate resolution:(NSString *)resolution andColourDepth:(NSString *)colourDepth;

- (void)addAudioWithCodec:(NSString *)codec andBitrate:(NSNumber *)bitrate;

- (NSManagedObject *)getStreamWithLanguage:(NSString *)language;
- (void)addSubsWithLanguage:(NSString *)language;
- (void)addDubsWithLanguage:(NSString *)language;

- (NSManagedObject *)addOtherEpisodeWithEpisode:(Episode *)episode andPercentage:(NSNumber *)percentage;

@end

@interface File (CoreDataGeneratedAccessors)

- (void)addOtherEpisodesObject:(NSManagedObject *)value;
- (void)removeOtherEpisodesObject:(NSManagedObject *)value;
- (void)addOtherEpisodes:(NSSet *)values;
- (void)removeOtherEpisodes:(NSSet *)values;

- (void)addAudioObject:(NSManagedObject *)value;
- (void)removeAudioObject:(NSManagedObject *)value;
- (void)addAudio:(NSSet *)values;
- (void)removeAudio:(NSSet *)values;

- (void)addDubsObject:(NSManagedObject *)value;
- (void)removeDubsObject:(NSManagedObject *)value;
- (void)addDubs:(NSSet *)values;
- (void)removeDubs:(NSSet *)values;

- (void)addSubsObject:(NSManagedObject *)value;
- (void)removeSubsObject:(NSManagedObject *)value;
- (void)addSubs:(NSSet *)values;
- (void)removeSubs:(NSSet *)values;

@end
