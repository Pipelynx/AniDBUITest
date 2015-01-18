//
//  AnimeCategory.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AnimeCategory.h"


@implementation AnimeCategory

@dynamic id;
@dynamic name;
@dynamic categoryInfos;

- (void)addAnime:(NSManagedObject *)anime withWeight:(NSNumber *)weight {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CategoryInfo"];
    NSError *error = nil;
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@", @"anime.id", [anime valueForKey:@"id"], @"category.id", self.id]];
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if ([result count] > 0)
        [result[0] setValue:weight forKey:@"weight"];
    else {
        NSManagedObject *temp = [[NSManagedObject alloc] initWithEntity:[NSEntityDescription entityForName:@"CategoryInfo" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
        [temp setValue:weight forKey:@"weight"];
        [temp setValue:anime forKey:@"anime"];
        [self addCategoryInfosObject:temp];
    }
}

@end
