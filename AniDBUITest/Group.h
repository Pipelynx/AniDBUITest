//
//  Group.h
//  AniDBUITest
//
//  Created by Martin Fellner on 20.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Mylist, Anime;



@interface Group : NSManagedObject

@property (nonatomic, retain) NSNumber * animeCount;
@property (nonatomic, retain) NSNumber * dateflags;
@property (nonatomic, retain) NSDate * disbanded;
@property (nonatomic, retain) NSNumber * fetched;
@property (nonatomic, retain) NSNumber * fetching;
@property (nonatomic, retain) NSNumber * fileCount;
@property (nonatomic, retain) NSDate * founded;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * ircChannel;
@property (nonatomic, retain) NSString * ircServer;
@property (nonatomic, retain) NSDate * lastActivity;
@property (nonatomic, retain) NSDate * lastRelease;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * ratingCount;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) NSSet *groupRelations;
@property (nonatomic, retain) NSSet *mylists;
@property (nonatomic, retain) NSSet *relatedGroups;
@property (nonatomic, retain) NSSet *groupStatuses;

@property (nonatomic, readonly) NSString *request;

- (NSURL *)getImageURLWithServer:(NSURL *)imageServer;

- (NSManagedObject *)addRelationWithGroup:(Group *)relatedGroup andType:(NSNumber *)type;

- (NSManagedObject *)addStatusWithAnime:(Anime *)anime completionState:(NSNumber *)completionState lastEpisodeNumber:(NSNumber *)lastEpisodeNumber rating:(NSNumber *)rating andRatingCount:(NSNumber *)ratingCount;

@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

- (void)addGroupRelationsObject:(NSManagedObject *)value;
- (void)removeGroupRelationsObject:(NSManagedObject *)value;
- (void)addGroupRelations:(NSSet *)values;
- (void)removeGroupRelations:(NSSet *)values;

- (void)addMylistsObject:(Mylist *)value;
- (void)removeMylistsObject:(Mylist *)value;
- (void)addMylists:(NSSet *)values;
- (void)removeMylists:(NSSet *)values;

- (void)addRelatedGroupsObject:(NSManagedObject *)value;
- (void)removeRelatedGroupsObject:(NSManagedObject *)value;
- (void)addRelatedGroups:(NSSet *)values;
- (void)removeRelatedGroups:(NSSet *)values;

- (void)addGroupStatusesObject:(NSManagedObject *)value;
- (void)removeGroupStatusesObject:(NSManagedObject *)value;
- (void)addGroupStatuses:(NSSet *)values;
- (void)removeGroupStatuses:(NSSet *)values;

@end
