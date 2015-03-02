//
//  Anime.m
//  AniDBUITest
//
//  Created by Martin Fellner on 04.02.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "DataClasses.h"
#import "MWLogging.h"


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
@dynamic categoryInfos;
@dynamic characterInfos;
@dynamic creatorInfos;
@dynamic episodes;
@dynamic files;
@dynamic groupStatuses;
@dynamic mylists;
@dynamic animeRelations;
@dynamic relatedAnime;

- (NSString *)request {
    return [ADBRequest requestAnimeWithID:self.id];
}

- (NSString *)groupStatusRequestWithState:(ADBGroupStatusState)state {
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

- (NSManagedObject *)addCharacterInfoWithCharacter:(Character *)character {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CharacterInfoEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@ AND character.id == %@", self.id, character.id]];
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (!error) {
        if (result.count == 0) {
            temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:CharacterInfoEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:character forKey:@"character"];
            [self addCharacterInfosObject:temp];
        }
    }
    else
        MWLogError(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    return temp;
}

- (NSManagedObject *)addAnimeRelationWithAnime:(Anime *)anime andType:(ADBAnimeRelationType)type {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:AnimeRelationEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@ AND relatedAnime.id == %@", self.id, anime.id]];
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (!error) {
        if (result.count == 0) {
            temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:AnimeRelationEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:anime forKey:@"relatedAnime"];
            [temp setValue:[NSNumber numberWithUnsignedInteger:type] forKey:@"type"];
            [self addAnimeRelationsObject:temp];
        }
    }
    else
        MWLogError(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    return temp;
}

- (NSArray *)groupStatusesWithState:(ADBGroupStatusState)state {
    if (state == ADBGroupStatusOngoingCompleteOrFinished) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:[self groupStatusesWithState:ADBGroupStatusOngoing]];
        [temp addObjectsFromArray:[self groupStatusesWithState:ADBGroupStatusComplete]];
        [temp addObjectsFromArray:[self groupStatusesWithState:ADBGroupStatusFinished]];
        return temp;
    }
    else {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:GroupStatusEntityIdentifier];
        NSError *error = nil;
        [request setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@ AND completionState == %i", self.id, state]];
        NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
        if (!error) {
            return result;
        }
        else
            MWLogError(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    }
    return nil;
}

- (void)setNoGroupStatusForState:(ADBGroupStatusState)state {
    if (state == ADBGroupStatusOngoingCompleteOrFinished) {
        [self setNoGroupStatusForState:ADBGroupStatusOngoing];
        [self setNoGroupStatusForState:ADBGroupStatusComplete];
        [self setNoGroupStatusForState:ADBGroupStatusFinished];
    }
    else {
        NSManagedObject *temp;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:GroupStatusEntityIdentifier];
        NSError *error = nil;
        [request setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@ AND completionState == %i AND group == nil", self.id, state]];
        NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
        if (!error) {
            if (result.count == 0) {
                temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:GroupStatusEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
                [temp setValue:[NSNumber numberWithInt:state] forKey:@"completionState"];
                [self addGroupStatusesObject:temp];
            }
        }
        else
            MWLogError(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    }
}

- (BOOL)hasNoGroupStatusForState:(ADBGroupStatusState)state {
    if (state == ADBGroupStatusOngoingCompleteOrFinished) {
        return [self hasNoGroupStatusForState:ADBGroupStatusOngoing] && [self hasNoGroupStatusForState:ADBGroupStatusComplete] && [self hasNoGroupStatusForState:ADBGroupStatusFinished];
    }
    else {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:GroupStatusEntityIdentifier];
        NSError *error = nil;
        [request setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@ AND completionState == %i AND group == nil", self.id, state]];
        NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
        if (!error) {
            if (result.count > 0)
                return YES;
        }
        else
            MWLogError(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    }
    return NO;
}

@end
