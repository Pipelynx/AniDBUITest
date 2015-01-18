//
//  Group.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 15.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "Group.h"
#import "File.h"
#import "Mylist.h"


@implementation Group

@dynamic animeCount;
@dynamic dateflags;
@dynamic disbanded;
@dynamic fetched;
@dynamic fileCount;
@dynamic founded;
@dynamic groupName;
@dynamic groupShortName;
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

- (NSString *)getRequest {
    return [ADBRequest createGroupWithID:self.id];
}

- (void)addRelationWithGroup:(Group *)relatedGroup andType:(NSNumber *)type {
    NSManagedObject *temp;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GroupRelation"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"group.id", self.id, @"relatedGroup.id", [(NSManagedObject *)relatedGroup valueForKey:@"id"]]];
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
}

@end
