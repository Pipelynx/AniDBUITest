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
#import "NSNumber+Utilities.h"

@class ADBPersistentConnection;
@protocol ADBPersistentConnectionDelegate<ADBConnectionDelegate>

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response;

@end

@interface ADBPersistentConnection : ADBConnection

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (ADBPersistentConnection *)sharedConnection;

- (void)addDelegate:(id<ADBPersistentConnectionDelegate>)delegate;
- (void)removeDelegate:(id<ADBPersistentConnectionDelegate>)delegate;

- (void)callDelegatesWithManagedObject:(NSManagedObject *)managedObject;
- (NSManagedObject *)parseResponseDictionary:(NSDictionary *)response;

- (BOOL)save:(NSError **)error;

- (Anime *)newAnimeWithID:(NSNumber *)animeID;
- (Anime *)newAnimeWithID:(NSNumber *)animeID andFetch:(BOOL)fetch;

- (Character *)newCharacterWithID:(NSNumber *)characterID;
- (Character *)newCharacterWithID:(NSNumber *)characterID andFetch:(BOOL)fetch;

- (Episode *)newEpisodeWithID:(NSNumber *)episodeID;
- (Episode *)newEpisodeWithID:(NSNumber *)episodeID andFetch:(BOOL)fetch;
- (Episode *)getEpisodeWithAnimeID:(NSNumber *)animeID episodeNumber:(NSNumber *)episodeNumber andType:(NSNumber *)type;
- (Episode *)getEpisodeWithAnimeID:(NSNumber *)animeID episodeNumber:(NSNumber *)episodeNumber type:(NSNumber *)type andFetch:(BOOL)fetch;
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

- (AnimeCategory *)newAnimeCategoryWithID:(NSNumber *)animeCategoryID;

@end
