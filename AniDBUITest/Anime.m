//
//  Anime.m
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "DataClasses.h"


@implementation Anime

@dynamic airDate;
@dynamic allcinemaID;
@dynamic animeNfoID;
@dynamic animePlanetID;
@dynamic annID;
@dynamic awardList;
@dynamic dateFlags;
@dynamic endDate;
@dynamic englishName;
@dynamic fetched;
@dynamic fetching;
@dynamic highestEpisodeNumber;
@dynamic id;
@dynamic imageName;
@dynamic kanjiName;
@dynamic numberOfCredits;
@dynamic numberOfEpisodes;
@dynamic numberOfOthers;
@dynamic numberOfParodies;
@dynamic numberOfSpecialEpisodes;
@dynamic numberOfSpecials;
@dynamic numberOfTrailers;
@dynamic rating;
@dynamic ratingCount;
@dynamic recordUpdated;
@dynamic restrict18;
@dynamic reviewCount;
@dynamic reviewRating;
@dynamic romajiName;
@dynamic tempRating;
@dynamic tempRatingCount;
@dynamic type;
@dynamic url;
@dynamic yearRange;
@dynamic alternativeSetting;
@dynamic alternativeVersion;
@dynamic categoryInfos;
@dynamic characterInfos;
@dynamic creatorInfos;
@dynamic episodes;
@dynamic files;
@dynamic fullStories;
@dynamic groupStatuses;
@dynamic mylists;
@dynamic otherRelations;
@dynamic parentStories;
@dynamic prequels;
@dynamic sameCharacters;
@dynamic sameSetting;
@dynamic sequels;
@dynamic sideStories;
@dynamic summaries;

- (void)setFetchedBits:(unsigned short)bitMask {
    self.fetched = [NSNumber numberWithUnsignedShort:[self.fetched unsignedShortValue] | bitMask];
}

- (BOOL)getFetchedBits:(unsigned short)bitMask {
    return (([self.fetched unsignedShortValue] & bitMask) == bitMask);
}

- (NSString *)getRequest {
    return [ADBRequest requestAnimeWithID:self.id];
}

- (NSString *)getCharacterRequest {
    return [ADBRequest requestAnimeWithID:self.id andMask:AM_CHARACTERS];
}

- (NSString *)getCreatorRequest {
    return [ADBRequest requestAnimeWithID:self.id andMask:AM_CREATORS | AM_MAIN_CREATORS];
}

- (NSString *)getGroupStatusRequestWithState:(short)state {
    if (state == ADBGroupStatusOngoingCompleteOrFinished)
        return [ADBRequest requestGroupStatusWithAnimeID:self.id];
    else
        return [ADBRequest requestGroupStatusWithAnimeID:self.id andState:state];
}

- (NSURL *)getImageURLWithServer:(NSURL *)imageServer {
    NSURL *url = [imageServer URLByAppendingPathComponent:@"pics/anime" isDirectory:YES];
    return [url URLByAppendingPathComponent:self.imageName];
}

- (NSString *)stringWithCategoriesSeparatedBy:(NSString *)separator {
    NSMutableString *temp = [NSMutableString string];
    for (NSManagedObject *categoryInfo in self.categoryInfos) {
        AnimeCategory *category = [categoryInfo valueForKey:@"category"];
        if ([temp isEqualToString:@""])
            [temp appendString:category.name];
        else
            [temp appendFormat:@"%@%@", separator, category.name];
    }
    return temp;
}

- (NSSet *)getRelatedAnime {
    NSMutableSet *temp = [NSMutableSet set];
    [temp addObjectsFromArray:[self.alternativeSetting allObjects]];
    [temp addObjectsFromArray:[self.alternativeVersion allObjects]];
    [temp addObjectsFromArray:[self.summaries allObjects]];
    [temp addObjectsFromArray:[self.fullStories allObjects]];
    [temp addObjectsFromArray:[self.sideStories allObjects]];
    [temp addObjectsFromArray:[self.parentStories allObjects]];
    [temp addObjectsFromArray:[self.prequels allObjects]];
    [temp addObjectsFromArray:[self.sequels allObjects]];
    [temp addObjectsFromArray:[self.sameCharacters allObjects]];
    [temp addObjectsFromArray:[self.sameSetting allObjects]];
    [temp addObjectsFromArray:[self.otherRelations allObjects]];
    return temp;
}

- (NSManagedObject *)addCharacterInfoWithCharacter:(Character *)character {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CharacterInfoEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"anime.id", self.id, @"character.id", [(NSManagedObject *)character valueForKey:@"id"]]];
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 0) {
            temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:CharacterInfoEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:character forKey:@"character"];
            [self addCharacterInfosObject:temp];
        }
    }
    else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    return temp;
}

@end
