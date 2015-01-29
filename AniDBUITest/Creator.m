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

- (NSString *)getRequest {
    return [ADBRequest createCreatorWithID:self.id];
}

- (NSURL *)getImageURLWithServer:(NSURL *)imageServer {
    NSURL *url = [imageServer URLByAppendingPathComponent:@"pics/anime" isDirectory:YES];
    return [url URLByAppendingPathComponent:self.imageName];
}

- (NSManagedObject *)addCreatorInfoWithAnime:(Anime *)anime isMainCreator:(NSNumber *)isMainCreator {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:CreatorInfoEntityIdentifier];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"anime.id", [(NSManagedObject *)anime valueForKey:@"id"], @"creator.id", self.id]];
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
