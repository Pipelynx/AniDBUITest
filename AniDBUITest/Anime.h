//
//  Anime.h
//  AniDBUITest
//
//  Created by Martin Fellner on 04.02.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode, File, Mylist, Character;

@interface Anime : NSManagedObject

@property (nonatomic, retain) NSDate * airDate;
@property (nonatomic, retain) NSString * allcinemaID;
@property (nonatomic, retain) NSString * animeNfoID;
@property (nonatomic, retain) NSString * animePlanetID;
@property (nonatomic, retain) NSString * annID;
@property (nonatomic, retain) NSString * awardList;
@property (nonatomic, retain) NSNumber * dateFlags;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSNumber * fetched;
@property (nonatomic, retain) NSNumber * fetching;
@property (nonatomic, retain) NSNumber * highestEpisodeNumber;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * kanjiName;
@property (nonatomic, retain) NSNumber * numberOfCredits;
@property (nonatomic, retain) NSNumber * numberOfEpisodes;
@property (nonatomic, retain) NSNumber * numberOfOthers;
@property (nonatomic, retain) NSNumber * numberOfParodies;
@property (nonatomic, retain) NSNumber * numberOfSpecialEpisodes;
@property (nonatomic, retain) NSNumber * numberOfSpecials;
@property (nonatomic, retain) NSNumber * numberOfTrailers;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * ratingCount;
@property (nonatomic, retain) NSDate * recordUpdated;
@property (nonatomic, retain) NSNumber * restrict18;
@property (nonatomic, retain) NSNumber * reviewCount;
@property (nonatomic, retain) NSNumber * reviewRating;
@property (nonatomic, retain) NSString * romajiName;
@property (nonatomic, retain) NSNumber * tempRating;
@property (nonatomic, retain) NSNumber * tempRatingCount;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * yearRange;
@property (nonatomic, retain) NSSet *categoryInfos;
@property (nonatomic, retain) NSSet *characterInfos;
@property (nonatomic, retain) NSSet *creatorInfos;
@property (nonatomic, retain) NSSet *episodes;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) NSSet *groupStatuses;
@property (nonatomic, retain) NSSet *mylists;
@property (nonatomic, retain) NSSet *animeRelations;
@property (nonatomic, retain) NSSet *relatedAnime;

- (void)setFetchedBits:(unsigned short)bitMask;

- (BOOL)isFetched:(unsigned short)bitMask;

- (NSString *)request;
- (NSString *)characterRequest;
- (NSString *)creatorRequest;
- (NSString *)groupStatusRequestWithState:(ADBGroupStatusState)state;

- (NSURL *)getImageURLWithServer:(NSURL *)imageServer;

- (NSString *)stringWithCategoriesSeparatedBy:(NSString *)separator;

- (NSManagedObject *)addCharacterInfoWithCharacter:(Character *)character;

- (NSManagedObject *)addAnimeRelationWithAnime:(Anime *)anime andType:(ADBAnimeRelationType)type;

@end

@interface Anime (CoreDataGeneratedAccessors)

- (void)addCategoryInfosObject:(NSManagedObject *)value;
- (void)removeCategoryInfosObject:(NSManagedObject *)value;
- (void)addCategoryInfos:(NSSet *)values;
- (void)removeCategoryInfos:(NSSet *)values;

- (void)addCharacterInfosObject:(NSManagedObject *)value;
- (void)removeCharacterInfosObject:(NSManagedObject *)value;
- (void)addCharacterInfos:(NSSet *)values;
- (void)removeCharacterInfos:(NSSet *)values;

- (void)addCreatorInfosObject:(NSManagedObject *)value;
- (void)removeCreatorInfosObject:(NSManagedObject *)value;
- (void)addCreatorInfos:(NSSet *)values;
- (void)removeCreatorInfos:(NSSet *)values;

- (void)addEpisodesObject:(Episode *)value;
- (void)removeEpisodesObject:(Episode *)value;
- (void)addEpisodes:(NSSet *)values;
- (void)removeEpisodes:(NSSet *)values;

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

- (void)addGroupStatusesObject:(NSManagedObject *)value;
- (void)removeGroupStatusesObject:(NSManagedObject *)value;
- (void)addGroupStatuses:(NSSet *)values;
- (void)removeGroupStatuses:(NSSet *)values;

- (void)addMylistsObject:(Mylist *)value;
- (void)removeMylistsObject:(Mylist *)value;
- (void)addMylists:(NSSet *)values;
- (void)removeMylists:(NSSet *)values;

- (void)addAnimeRelationsObject:(NSManagedObject *)value;
- (void)removeAnimeRelationsObject:(NSManagedObject *)value;
- (void)addAnimeRelations:(NSSet *)values;
- (void)removeAnimeRelations:(NSSet *)values;

- (void)addRelatedAnimeObject:(NSManagedObject *)value;
- (void)removeRelatedAnimeObject:(NSManagedObject *)value;
- (void)addRelatedAnime:(NSSet *)values;
- (void)removeRelatedAnime:(NSSet *)values;

@end
