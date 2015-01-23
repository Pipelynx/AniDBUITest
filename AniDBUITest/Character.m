//
//  Character.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "Character.h"


@implementation Character

@dynamic id;
@dynamic fetched;
@dynamic gender;
@dynamic imageName;
@dynamic kanjiName;
@dynamic recordUpdated;
@dynamic romajiName;
@dynamic type;
@dynamic characterInfos;

- (NSString *)getRequest {
    return [ADBRequest createCharacterWithID:self.id];
}

- (NSManagedObject *)addCharacterInfoWithAnime:(Anime *)anime creator:(Creator *)creator appearanceType:(NSNumber *)appearanceType andIsMainSeiyuu:(NSNumber *)isMainSeiyuu {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CharacterInfo"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"anime.id", [(NSManagedObject *)anime valueForKey:@"id"], @"character.id", self.id]];
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if ([result count] > 0)
        temp = result[0];
    else {
        temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"CharacterInfo" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
        [temp setValue:anime forKey:@"anime"];
        [self addCharacterInfosObject:temp];
    }
    [temp setValue:creator forKey:@"creator"];
    [temp setValue:appearanceType forKey:@"appearanceType"];
    [temp setValue:isMainSeiyuu forKey:@"isMainSeiyuu"];
    return temp;
}

@end
