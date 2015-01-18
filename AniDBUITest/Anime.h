//
//  Anime.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 15.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ADBRequest.h"

@class Anime, Character, Creator, Episode, File, Mylist;

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
@property (nonatomic, retain) NSSet *alternativeSetting;
@property (nonatomic, retain) NSSet *alternativeVersion;
@property (nonatomic, retain) NSSet *categoryInfos;
@property (nonatomic, retain) NSSet *characterInfos;
@property (nonatomic, retain) NSSet *episodes;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) NSSet *fullStories;
@property (nonatomic, retain) NSSet *mylists;
@property (nonatomic, retain) NSSet *otherRelations;
@property (nonatomic, retain) NSSet *parentStories;
@property (nonatomic, retain) NSSet *prequels;
@property (nonatomic, retain) NSSet *sameCharacters;
@property (nonatomic, retain) NSSet *sameSetting;
@property (nonatomic, retain) NSSet *sequels;
@property (nonatomic, retain) NSSet *sideStories;
@property (nonatomic, retain) NSSet *summaries;
@property (nonatomic, retain) NSSet *creators;
@property (nonatomic, retain) NSSet *mainCreators;

- (NSString *)getRequest;

- (NSSet *)getRelatedAnime;

- (void)addCharacterInfoWithCharacter:(Character *)character;

@end

@interface Anime (CoreDataGeneratedAccessors)

- (void)addAlternativeSettingObject:(Anime *)value;
- (void)removeAlternativeSettingObject:(Anime *)value;
- (void)addAlternativeSetting:(NSSet *)values;
- (void)removeAlternativeSetting:(NSSet *)values;

- (void)addAlternativeVersionObject:(Anime *)value;
- (void)removeAlternativeVersionObject:(Anime *)value;
- (void)addAlternativeVersion:(NSSet *)values;
- (void)removeAlternativeVersion:(NSSet *)values;

- (void)addCategoryInfosObject:(NSManagedObject *)value;
- (void)removeCategoryInfosObject:(NSManagedObject *)value;
- (void)addCategoryInfos:(NSSet *)values;
- (void)removeCategoryInfos:(NSSet *)values;

- (void)addCharacterInfosObject:(NSManagedObject *)value;
- (void)removeCharacterInfosObject:(NSManagedObject *)value;
- (void)addCharacterInfos:(NSSet *)values;
- (void)removeCharacterInfos:(NSSet *)values;

- (void)addEpisodesObject:(Episode *)value;
- (void)removeEpisodesObject:(Episode *)value;
- (void)addEpisodes:(NSSet *)values;
- (void)removeEpisodes:(NSSet *)values;

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

- (void)addFullStoriesObject:(Anime *)value;
- (void)removeFullStoriesObject:(Anime *)value;
- (void)addFullStories:(NSSet *)values;
- (void)removeFullStories:(NSSet *)values;

- (void)addMylistsObject:(Mylist *)value;
- (void)removeMylistsObject:(Mylist *)value;
- (void)addMylists:(NSSet *)values;
- (void)removeMylists:(NSSet *)values;

- (void)addOtherRelationsObject:(Anime *)value;
- (void)removeOtherRelationsObject:(Anime *)value;
- (void)addOtherRelations:(NSSet *)values;
- (void)removeOtherRelations:(NSSet *)values;

- (void)addParentStoriesObject:(Anime *)value;
- (void)removeParentStoriesObject:(Anime *)value;
- (void)addParentStories:(NSSet *)values;
- (void)removeParentStories:(NSSet *)values;

- (void)addPrequelsObject:(Anime *)value;
- (void)removePrequelsObject:(Anime *)value;
- (void)addPrequels:(NSSet *)values;
- (void)removePrequels:(NSSet *)values;

- (void)addSameCharactersObject:(Anime *)value;
- (void)removeSameCharactersObject:(Anime *)value;
- (void)addSameCharacters:(NSSet *)values;
- (void)removeSameCharacters:(NSSet *)values;

- (void)addSameSettingObject:(Anime *)value;
- (void)removeSameSettingObject:(Anime *)value;
- (void)addSameSetting:(NSSet *)values;
- (void)removeSameSetting:(NSSet *)values;

- (void)addSequelsObject:(Anime *)value;
- (void)removeSequelsObject:(Anime *)value;
- (void)addSequels:(NSSet *)values;
- (void)removeSequels:(NSSet *)values;

- (void)addSideStoriesObject:(Anime *)value;
- (void)removeSideStoriesObject:(Anime *)value;
- (void)addSideStories:(NSSet *)values;
- (void)removeSideStories:(NSSet *)values;

- (void)addSummariesObject:(Anime *)value;
- (void)removeSummariesObject:(Anime *)value;
- (void)addSummaries:(NSSet *)values;
- (void)removeSummaries:(NSSet *)values;

- (void)addCreatorsObject:(Creator *)value;
- (void)removeCreatorsObject:(Creator *)value;
- (void)addCreators:(NSSet *)values;
- (void)removeCreators:(NSSet *)values;

- (void)addMainCreatorsObject:(Creator *)value;
- (void)removeMainCreatorsObject:(Creator *)value;
- (void)addMainCreators:(NSSet *)values;
- (void)removeMainCreators:(NSSet *)values;

@end
