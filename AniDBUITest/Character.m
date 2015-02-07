//
//  Character.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "DataClasses.h"


@implementation Character

@dynamic id;
@dynamic fetched;
@dynamic fetching;
@dynamic gender;
@dynamic imageName;
@dynamic kanjiName;
@dynamic recordUpdated;
@dynamic romajiName;
@dynamic type;
@dynamic characterInfos;

- (NSString *)typeString {
    switch ([self.type intValue]) {
        case 1: return @"Character";
        case 2: return @"Mecha";
        case 3: return @"Organisation";
        case 4: return @"Vessel";
        default: return nil;
    }
}

- (NSString *)genderString {
    if ([self.gender isEqualToString:@"M"])
        return @"Male";
    if ([self.gender isEqualToString:@"F"])
        return @"Female";
    if ([self.gender isEqualToString:@"I"])
        return @"Intersexual";
    if ([self.gender isEqualToString:@"D"])
        return @"Dimorphic";
    if ([self.gender isEqualToString:@"-"])
        return @"None";
    return @"Unknown";
}

- (NSString *)getRequest {
    return [ADBRequest requestCharacterWithID:self.id];
}

- (NSURL *)getImageURLWithServer:(NSURL *)imageServer {
    NSURL *url = [imageServer URLByAppendingPathComponent:@"pics/anime" isDirectory:YES];
    return [url URLByAppendingPathComponent:self.imageName];
}

- (NSManagedObject *)addCharacterInfoWithAnime:(Anime *)anime creator:(Creator *)creator appearanceType:(NSNumber *)appearanceType andIsMainSeiyuu:(NSNumber *)isMainSeiyuu {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CharacterInfoEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"anime.id", [(NSManagedObject *)anime valueForKey:@"id"], @"character.id", self.id]];
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if ([result count] > 0)
        temp = result[0];
    else {
        temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:CharacterInfoEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
        [temp setValue:anime forKey:@"anime"];
        [self addCharacterInfosObject:temp];
    }
    [temp setValue:creator forKey:@"creator"];
    [temp setValue:appearanceType forKey:@"appearanceType"];
    [temp setValue:isMainSeiyuu forKey:@"isMainSeiyuu"];
    return temp;
}

@end
