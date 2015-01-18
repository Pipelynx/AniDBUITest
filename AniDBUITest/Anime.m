//
//  Anime.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 15.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "Anime.h"
#import "Anime.h"
#import "Creator.h"
#import "Episode.h"
#import "File.h"
#import "Mylist.h"


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
@dynamic episodes;
@dynamic files;
@dynamic fullStories;
@dynamic mylists;
@dynamic otherRelations;
@dynamic parentStories;
@dynamic prequels;
@dynamic sameCharacters;
@dynamic sameSetting;
@dynamic sequels;
@dynamic sideStories;
@dynamic summaries;
@dynamic creators;
@dynamic mainCreators;

- (NSString *)getRequest {
    return [ADBRequest createAnimeWithID:self.id];
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

- (void)addCharacterInfoWithCharacter:(Character *)character {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CharacterInfo"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"anime.id", self.id, @"character.id", [(NSManagedObject *)character valueForKey:@"id"]]];
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 0) {
            NSManagedObject *temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"CharacterInfo" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:character forKey:@"character"];
            [self addCharacterInfosObject:temp];
        }
    }
    else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
}

@end
