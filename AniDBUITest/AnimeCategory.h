//
//  AnimeCategory.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AnimeCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *categoryInfos;

- (void)addAnime:(NSManagedObject *)anime withWeight:(NSNumber *)weight;

@end

@interface AnimeCategory (CoreDataGeneratedAccessors)

- (void)addCategoryInfosObject:(NSManagedObject *)value;
- (void)removeCategoryInfosObject:(NSManagedObject *)value;
- (void)addCategoryInfos:(NSSet *)values;
- (void)removeCategoryInfos:(NSSet *)values;

@end
