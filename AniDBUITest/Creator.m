//
//  Creator.m
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "DataClasses.h"


@implementation Creator

@dynamic fetched;
@dynamic fetching;
@dynamic id;
@dynamic imageName;
@dynamic kanjiName;
@dynamic recordUpdated;
@dynamic romajiName;
@dynamic type;
@dynamic urlEnglish;
@dynamic urlJapanese;
@dynamic wikiEnglish;
@dynamic wikiJapanese;
@dynamic creatorInfos;
@dynamic characters;

- (NSString *)typeString {
    switch ([self.type intValue]) {
        case 1: return @"Person";
        case 2: return @"Company";
        case 3: return @"Collaboration";
        default: return nil;
    }
}

- (NSString *)getRequest {
    return [ADBRequest requestCreatorWithID:self.id];
}

- (NSURL *)getImageURLWithServer:(NSURL *)imageServer {
    NSURL *url = [imageServer URLByAppendingPathComponent:@"pics/anime" isDirectory:YES];
    return [url URLByAppendingPathComponent:self.imageName];
}

- (NSManagedObject *)addCreatorInfoWithAnime:(Anime *)anime isMainCreator:(NSNumber *)isMainCreator {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CreatorInfoEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"anime.id == %@ AND creator.id == %@", anime.id, self.id]];
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if ([result count] > 0)
        temp = result[0];
    else {
        temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:CreatorInfoEntityIdentifier inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
        [temp setValue:anime forKey:@"anime"];
        [self addCreatorInfosObject:temp];
    }
    [temp setValue:isMainCreator forKey:@"isMainCreator"];
    return temp;
}

@end
