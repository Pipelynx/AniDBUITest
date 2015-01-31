//
//  ADBPersistentConnection.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ADBConnection.h"
#import "DataClasses.h"

typedef enum {
    ADBAnimeFetchedAnime =              0b000000000001,
    ADBAnimeFetchedCategories =         0b000000000010,
    ADBAnimeFetchedRelatedAnime =       0b000000000100,
    ADBAnimeFetchedCharacters =         0b000000001000,
    ADBAnimeFetchedCreators =           0b000000010000,
    ADBAnimeFetchedMainCreators =       0b000000100000,
    ADBAnimeFetchedOngoingGroups =      0b000001000000,
    ADBAnimeFetchedStalledGroups =      0b000010000000,
    ADBAnimeFetchedCompleteGroups =     0b000100000000,
    ADBAnimeFetchedDroppedGroups =      0b001000000000,
    ADBAnimeFetchedFinishedGroups =     0b010000000000,
    ADBAnimeFetchedSpecialsOnlyGroups = 0b100000000000,
    ADBAnimeFetchedGroups =             0b111111000000
} ADBAnimeFetched;

@class ADBPersistentConnection;
@protocol ADBPersistentConnectionDelegate<ADBConnectionDelegate>

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response;

@end

@interface ADBPersistentConnection : ADBConnection

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

#pragma mark - Setup

+ (ADBPersistentConnection *)sharedConnection;

- (void)addDelegate:(id<ADBPersistentConnectionDelegate>)delegate;
- (void)removeDelegate:(id<ADBPersistentConnectionDelegate>)delegate;

- (void)callDelegatesWithManagedObject:(NSManagedObject *)managedObject;

#pragma mark - Parsing

- (NSManagedObject *)parseResponseDictionary:(NSDictionary *)response;

#pragma mark - Managed objects

- (BOOL)save:(NSError **)error;

- (void)fetch:(NSManagedObject *)managedObject;

- (Anime *)newAnimeWithID:(NSNumber *)animeID;
- (Anime *)newAnimeWithID:(NSNumber *)animeID andFetch:(BOOL)fetch;

- (Character *)newCharacterWithID:(NSNumber *)characterID;
- (Character *)newCharacterWithID:(NSNumber *)characterID andFetch:(BOOL)fetch;

- (Episode *)newEpisodeWithID:(NSNumber *)episodeID;
- (Episode *)newEpisodeWithID:(NSNumber *)episodeID andFetch:(BOOL)fetch;
- (Episode *)getEpisodeWithAnimeID:(NSNumber *)animeID episodeNumber:(NSNumber *)episodeNumber andType:(NSNumber *)type;
- (Episode *)newEpisodeWithAnimeID:(NSNumber *)animeID episodeNumber:(NSNumber *)episodeNumber andType:(NSNumber *)type;
- (Episode *)newEpisodeWithAnimeID:(NSNumber *)animeID episodeNumber:(NSNumber *)episodeNumber type:(NSNumber *)type andFetch:(BOOL)fetch;

- (Group *)newGroupWithID:(NSNumber *)groupID;
- (Group *)newGroupWithID:(NSNumber *)groupID andFetch:(BOOL)fetch;

- (Mylist *)newMylistWithID:(NSNumber *)mylistID;
- (Mylist *)newMylistWithID:(NSNumber *)mylistID andFetch:(BOOL)fetch;

- (Creator *)newCreatorWithID:(NSNumber *)creatorID;
- (Creator *)newCreatorWithID:(NSNumber *)creatorID andFetch:(BOOL)fetch;

- (File *)newFileWithID:(NSNumber *)fileID;
- (File *)newFileWithID:(NSNumber *)fileID andFetch:(BOOL)fetch;
- (File *)newFileWithAnime:(Anime *)anime group:(Group *)group andEpisode:(Episode *)episode;
- (File *)newFileWithAnime:(Anime *)anime group:(Group *)group andEpisode:(Episode *)episode andFetch:(BOOL)fetch;

- (AnimeCategory *)newAnimeCategoryWithID:(NSNumber *)animeCategoryID;

- (void)invalidate:(NSManagedObject *)managedObject;

@end
