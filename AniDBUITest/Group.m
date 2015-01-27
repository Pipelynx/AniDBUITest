//
//  Group.m
//  AniDBUITest
//
//  Created by Martin Fellner on 20.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "Group.h"
#import "File.h"
#import "Mylist.h"
#import "Anime.h"


@implementation Group

@dynamic animeCount;
@dynamic dateflags;
@dynamic disbanded;
@dynamic fetched;
@dynamic fileCount;
@dynamic founded;
@dynamic name;
@dynamic shortName;
@dynamic id;
@dynamic imageName;
@dynamic ircChannel;
@dynamic ircServer;
@dynamic lastActivity;
@dynamic lastRelease;
@dynamic rating;
@dynamic ratingCount;
@dynamic url;
@dynamic files;
@dynamic groupRelations;
@dynamic mylists;
@dynamic relatedGroups;
@dynamic groupStatuses;

- (NSString *)getRequest {
    return [ADBRequest createGroupWithID:self.id];
}

- (NSManagedObject *)addRelationWithGroup:(Group *)relatedGroup andType:(NSNumber *)type {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GroupRelation"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"group.id", self.id, @"relatedGroup.id", relatedGroup.id]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = result[0];
        else {
            temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"GroupRelation" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:relatedGroup forKey:@"relatedGroup"];
            [self addGroupRelationsObject:temp];
        }
        [temp setValue:type forKey:@"type"];
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    return temp;
}

- (NSManagedObject *)addStatusWithAnime:(Anime *)anime completionState:(NSNumber *)completionState lastEpisodeNumber:(NSNumber *)lastEpisodeNumber rating:(NSNumber *)rating andRatingCount:(NSNumber *)ratingCount {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GroupStatus"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"group.id", self.id, @"anime.id", anime.id]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = result[0];
        else {
            temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"GroupStatus" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:anime forKey:@"anime"];
            [self addGroupStatusesObject:temp];
        }
        [temp setValue:completionState forKey:@"completionState"];
        [temp setValue:lastEpisodeNumber forKey:@"lastEpisodeNumber"];
        [temp setValue:rating forKey:@"rating"];
        [temp setValue:ratingCount forKey:@"ratingCount"];
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    return temp;
}

@end
