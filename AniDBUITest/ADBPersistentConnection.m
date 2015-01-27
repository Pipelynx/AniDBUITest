//
//  ADBPersistentConnection.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#define EPISODE_TYPES [NSDictionary dictionaryWithObjectsAndKeys:@1, @"numberOfEpisodes", @2, @"numberOfSpecials", @3, @"numberOfCredits", @4, @"numberOfTrailers", @5, @"numberOfParodies", @6, @"numberOfOthers", nil]

#import "ADBPersistentConnection.h"

@interface ADBPersistentConnection ()

@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation ADBPersistentConnection

#pragma mark - Setup

+ (ADBPersistentConnection *)sharedConnection {
    static ADBPersistentConnection *sharedConnection = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{ sharedConnection = [[self alloc] init]; });
    return sharedConnection;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)addDelegate:(id<ADBPersistentConnectionDelegate>)delegate
{
    [super addDelegate:delegate];
}

- (void)removeDelegate:(id<ADBPersistentConnectionDelegate>)delegate
{
    [super removeDelegate:delegate];
}

- (void)parse:(NSString *)response {
    NSDictionary *tempDict = [super parseResponse:response];
    NSManagedObject *tempObject = [self parseResponseDictionary:tempDict];
    if (tempObject)
        [self callDelegatesWithManagedObject:tempObject];
    else
        [super callDelegatesWithDictionary:tempDict];
}

#pragma mark - Parsing

- (NSManagedObject *)parseResponseDictionary:(NSDictionary *)response {
    NSManagedObject *temp;
    Anime *anime;
    AnimeCategory *animeCategory;
    Creator *creator;
    Character *character;
    Episode *episode;
    File *file;
    Group *group;
    NSDictionary *dict;
    NSArray *a1, *a2, *a3;
    NSString *IDString;
    NSNumber *ID;
    
    int code = [response[@"responseType"] intValue];
    
    switch (code) {
        case ADBResponseCodeAnime: {
            anime = [self newAnimeWithID:[NSNumber numberWithLongLong:[response[@"id"] longLongValue]]];
            [self setValues:response forManagedObject:anime];
            [anime setFetchedBits:ADBAnimeFetchedAnime];
            
            NSDictionary *episodeTypes = EPISODE_TYPES;
            for (NSString *key in episodeTypes) {
                IDString = response[key];
                if (IDString)
                    for (int i = 1; i <= [IDString intValue]; i++) {
                        if (![self getEpisodeWithAnimeID:anime.id episodeNumber:[NSNumber numberWithInt:i] andType:episodeTypes[key]])
                            [self newEpisodeWithAnimeID:anime.id episodeNumber:[NSNumber numberWithInt:i] andType:episodeTypes[key]];
                    }
            }
            
            IDString = response[@"categoryIDList"];
            if (IDString && response[@"categoryNameList"] && response[@"categoryWeightList"]) {
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@","];
                    a2 = [response[@"categoryNameList"] componentsSeparatedByString:@","];
                    a3 = [response[@"categoryWeightList"] componentsSeparatedByString:@","];
                    for (int i = 0; i < [a1 count]; i++) {
                        animeCategory = [self newAnimeCategoryWithID:[NSNumber numberWithString:a1[i]]];
                        if (![animeCategory.name isEqualToString:a2[i]])
                            [animeCategory setName:a2[i]];
                        [animeCategory addAnime:anime withWeight:[NSNumber numberWithString:a3[i]]];
                    }
                }
                [anime setFetchedBits:ADBAnimeFetchedCategories];
            }
            
            IDString = response[@"characterIDList"];
            if (IDString) {
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@","];
                    for (int i = 0; i < [a1 count]; i++) {
                        [anime addCharacterInfoWithCharacter:[self newCharacterWithID:[NSNumber numberWithString:a1[i]]]];
                    }
                }
                [anime setFetchedBits:ADBAnimeFetchedCharacters];
            }
            
            IDString = response[@"creatorIDList"];
            if (IDString) {
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@","];
                    for (int i = 0; i < [a1 count]; i++) {
                        [anime addCreatorsObject:[self newCreatorWithID:[NSNumber numberWithString:a1[i]]]];
                    }
                }
                [anime setFetchedBits:ADBAnimeFetchedCreators];
            }
            
            IDString = response[@"mainCreatorIDList"];
            if (IDString) {
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@","];
                    a2 = nil;
                    if (response[@"mainCreatorNameList"])
                        a2 = [response[@"mainCreatorNameList"] componentsSeparatedByString:@","];
                    for (int i = 0; i < [a1 count]; i++) {
                        creator = [self newCreatorWithID:[NSNumber numberWithString:a1[i]]];
                        if (a2)
                            [creator setRomajiName:a2[i]];
                        [anime addMainCreatorsObject:creator];
                    }
                }
                [anime setFetchedBits:ADBAnimeFetchedMainCreators];
            }
            
            IDString = response[@"relatedAnimeIDList"];
            if (IDString && response[@"relatedAnimeTypeList"]) {
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@"'"];
                    a2 = [response[@"relatedAnimeTypeList"] componentsSeparatedByString:@"'"];
                    for (int i = 0; i < [a1 count]; i++) {
                        ID = [NSNumber numberWithString:a1[i]];
                        switch ([a2[i] intValue]) {
                            case 1: [[anime mutableSetValueForKey:@"sequels"] addObject:[self newAnimeWithID:ID]]; break;
                            case 2: [[anime mutableSetValueForKey:@"prequels"] addObject:[self newAnimeWithID:ID]]; break;
                            case 11: [[anime mutableSetValueForKey:@"sameSetting"] addObject:[self newAnimeWithID:ID]]; break;
                            case 12: [[anime mutableSetValueForKey:@"alternativeSetting"] addObject:[self newAnimeWithID:ID]]; break;
                            case 32: [[anime mutableSetValueForKey:@"alternativeVersion"] addObject:[self newAnimeWithID:ID]]; break;
                            case 41: break;
                            case 42: [[anime mutableSetValueForKey:@"sameCharacters"] addObject:[self newAnimeWithID:ID]]; break;
                            case 51: [[anime mutableSetValueForKey:@"sideStories"] addObject:[self newAnimeWithID:ID]]; break;
                            case 52: [[anime mutableSetValueForKey:@"parentStories"] addObject:[self newAnimeWithID:ID]]; break;
                            case 61: [[anime mutableSetValueForKey:@"summaries"] addObject:[self newAnimeWithID:ID]]; break;
                            case 62: [[anime mutableSetValueForKey:@"fullStories"] addObject:[self newAnimeWithID:ID]]; break;
                            case 100: [[anime mutableSetValueForKey:@"otherRelations"] addObject:[self newAnimeWithID:ID]]; break;
                            default: break;
                        }
                    }
                }
                [anime setFetchedBits:ADBAnimeFetchedRelatedAnime];
            }
            return anime;
        }
        case ADBResponseCodeCharacter:
            character = [self newCharacterWithID:[NSNumber numberWithLongLong:[response[@"id"] longLongValue]]];
            [self setValues:response forManagedObject:character];
            [character setValue:@YES forKey:@"fetched"];
            
            IDString = response[@"animeBlocks"];
            if (IDString)
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@"'"];
                    for (NSString *block in a1) {
                        a2 = [block componentsSeparatedByString:@","];
                        [character addCharacterInfoWithAnime:[self newAnimeWithID:[NSNumber numberWithString:a2[0]]] creator:[self newCreatorWithID:[NSNumber numberWithString:a2[2]]] appearanceType:[NSNumber numberWithString:a2[1]] andIsMainSeiyuu:[NSNumber numberWithString:a2[3]]];
                    }
                }
            return character;
            
        case ADBResponseCodeCreator:
            creator = [self newCreatorWithID:[NSNumber numberWithLongLong:[response[@"id"] longLongValue]]];
            [self setValues:response forManagedObject:creator];
            [creator setValue:@YES forKey:@"fetched"];
            return creator;
            
        case ADBResponseCodeEpisode:
            [response setValue:[response[@"episodeNumber"] stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]] forKey:@"episodeNumber"];
            episode = [self getEpisodeWithAnimeID:[NSNumber numberWithString:response[@"animeID"]] episodeNumber:[NSNumber numberWithString:response[@"episodeNumber"]] andType:[NSNumber numberWithString:response[@"type"]]];
            if (!episode)
                episode = [self newEpisodeWithID:[NSNumber numberWithString:response[@"id"]]];
            [self setValues:response forManagedObject:episode];
            [episode setValue:@YES forKey:@"fetched"];
            
            IDString = response[@"animeID"];
            if (IDString)
                [episode setAnime:[self newAnimeWithID:[NSNumber numberWithString:IDString]]];
            return episode;
            
        case ADBResponseCodeFile:
            file = [self newFileWithID:[NSNumber numberWithLongLong:[response[@"id"] longLongValue]]];
            [self setValues:response forManagedObject:file];
            [file setValue:@YES forKey:@"fetched"];
            
            IDString = response[@"animeID"];
            if (IDString)
                [file setAnime:[self newAnimeWithID:[NSNumber numberWithString:IDString]]];
            
            IDString = response[@"episodeID"];
            if (IDString)
                [file setEpisode:[self newEpisodeWithID:[NSNumber numberWithString:IDString]]];
            
            IDString = response[@"groupID"];
            if (IDString)
                [file setGroup:[self newGroupWithID:[NSNumber numberWithString:IDString]]];
            
            if (response[@"videoCodec"] && response[@"videoBitrate"] && response[@"videoResolution"] && response[@"videoColourDepth"])
                [file setVideoWithCodec:response[@"videoCodec"] bitrate:[NSNumber numberWithString:response[@"videoBitrate"]] resolution:response[@"videoResolution"] andColourDepth:response[@"videoColourDepth"]];
            
            IDString = response[@"audioCodecList"];
            if (IDString && response[@"audioBitrateList"])
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@"'"];
                    a2 = [response[@"audioBitRateList"] componentsSeparatedByString:@"'"];
                    for (int i = 0; i < [a1 count]; i++)
                        [file addAudioWithCodec:a1[i] andBitrate:[NSNumber numberWithString:a2[i]]];
                }
            
            IDString = response[@"subLanguage"];
            if (IDString)
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@"'"];
                    for (int i = 0; i < [a1 count]; i++)
                        [file addSubsWithLanguage:a1[0]];
                }
            
            IDString = response[@"dubLanguage"];
            if (IDString)
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@"'"];
                    for (int i = 0; i < [a1 count]; i++)
                        [file addDubsWithLanguage:a1[0]];
                }
            
            IDString = response[@"otherEpisodeList"];
            if (IDString)
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@"'"];
                    for (NSString *block in a1)
                        a2 = [block componentsSeparatedByString:@","];
                    [file addOtherEpisodeWithEpisode:[self newEpisodeWithID:[NSNumber numberWithString:a2[0]]] andPercentage:[NSNumber numberWithString:a2[1]]];
                }
            return file;
            
        case ADBResponseCodeMultipleFilesFound:
            for (NSString *fileID in response[@"fileIDs"])
                [self sendRequest:[ADBRequest createFileWithID:[NSNumber numberWithString:fileID]]];
            return nil;
            
        case ADBResponseCodeGroup:
            group = [self newGroupWithID:[NSNumber numberWithLongLong:[response[@"id"] longLongValue]]];
            [self setValues:response forManagedObject:group];
            [group setValue:@YES forKey:@"fetched"];
            
            IDString = response[@"relations"];
            if (IDString)
                if (![IDString isEqualToString:@""]) {
                    a1 = [IDString componentsSeparatedByString:@"'"];
                    for (NSString *block in a1)
                        a2 = [block componentsSeparatedByString:@","];
                    [group addRelationWithGroup:[self newGroupWithID:[NSNumber numberWithString:a2[0]]] andType:[NSNumber numberWithString:a2[1]]];
                }
            return group;
            
        case ADBResponseCodeGroupStatus:
            for (NSString *groupID in response[@"groups"]) {
                dict = response[@"groups"][groupID];
                group = [self newGroupWithID:[NSNumber numberWithString:groupID]];
                anime = [self newAnimeWithID:[NSNumber numberWithString:response[@"tag"]]];
                temp = [group addStatusWithAnime:anime completionState:[NSNumber numberWithString:dict[@"completionState"]] lastEpisodeNumber:[NSNumber numberWithString:dict[@"lastEpisodeNumber"]] rating:[NSNumber numberWithString:dict[@"rating"]] andRatingCount:[NSNumber numberWithString:dict[@"ratingCount"]]];
                [temp setValue:[self episodesWithRange:dict[@"episodeRange"] animeID:anime.id andType:@1] forKey:@"episodes"];
            }
            IDString = [ADBRequest extractAttribute:@"state" fromRequest:response[@"request"]];
            if (!IDString)
                IDString = @"0";
            switch ([IDString intValue]) {
                case 0: [anime setFetchedBits:(ADBAnimeFetchedOngoingGroups | ADBAnimeFetchedFinishedGroups | ADBAnimeFetchedCompleteGroups)]; break;
                case 1: [anime setFetchedBits:ADBAnimeFetchedOngoingGroups]; break;
                case 2: [anime setFetchedBits:ADBAnimeFetchedStalledGroups]; break;
                case 3: [anime setFetchedBits:ADBAnimeFetchedCompleteGroups]; break;
                case 4: [anime setFetchedBits:ADBAnimeFetchedDroppedGroups]; break;
                case 5: [anime setFetchedBits:ADBAnimeFetchedFinishedGroups]; break;
                case 6: [anime setFetchedBits:ADBAnimeFetchedSpecialsOnlyGroups]; break;
                default: break;
            }
            return temp;
            
        case ADBResponseCodeNoSuchGroupsFound:
            IDString = [ADBRequest extractAttribute:@"state" fromRequest:response[@"request"]];
            if (!IDString)
                IDString = @"0";
            switch ([IDString intValue]) {
                case 0: [anime setFetchedBits:(ADBAnimeFetchedOngoingGroups | ADBAnimeFetchedFinishedGroups | ADBAnimeFetchedCompleteGroups)]; break;
                case 1: [anime setFetchedBits:ADBAnimeFetchedOngoingGroups]; break;
                case 2: [anime setFetchedBits:ADBAnimeFetchedStalledGroups]; break;
                case 3: [anime setFetchedBits:ADBAnimeFetchedCompleteGroups]; break;
                case 4: [anime setFetchedBits:ADBAnimeFetchedDroppedGroups]; break;
                case 5: [anime setFetchedBits:ADBAnimeFetchedFinishedGroups]; break;
                case 6: [anime setFetchedBits:ADBAnimeFetchedSpecialsOnlyGroups]; break;
                default: break;
            }
            return nil;
            
        default:
            return nil;
    }
    return nil;
}

#pragma mark - Managed objects

- (void)setValues:(NSDictionary *)values forManagedObject:(NSManagedObject *)managedObject {
    for (NSString *p in [[managedObject entity] attributesByName])
        switch ([[[[managedObject entity] attributesByName] objectForKey:p] attributeType]) {
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
            case NSBooleanAttributeType:
                if ([[managedObject valueForKey:p] isEqualToNumber:@0])
                    [managedObject setValue:[NSNumber numberWithLongLong:[values[p] longLongValue]] forKey:p];
                break;
            case NSStringAttributeType:
                if (![managedObject valueForKey:p])
                    [managedObject setValue:values[p] forKey:p];
                break;
            case NSDateAttributeType:
                if (![managedObject valueForKey:p])
                    [managedObject setValue:[NSDate dateWithTimeIntervalSince1970:[values[p] doubleValue]] forKey:p];
                break;
            default:
                break;
        }
}

- (NSSet *)episodesWithRange:(NSString *)episodeRange animeID:(NSNumber *)animeID andType:(NSNumber *)type {
    NSMutableSet *episodes = [NSMutableSet set];
    Episode *episode = nil;
    for (NSString *sequence in [episodeRange componentsSeparatedByString:@","])
        if ([sequence rangeOfString:@"-"].location != NSNotFound)
            for (int i = [[sequence componentsSeparatedByString:@"-"][0] intValue]; i <= [[sequence componentsSeparatedByString:@"-"][1] intValue]; i++) {
                episode = [self getEpisodeWithAnimeID:animeID episodeNumber:[NSNumber numberWithInt:i] andType:type];
                if (!episode)
                    episode = [self newEpisodeWithAnimeID:animeID episodeNumber:[NSNumber numberWithInt:i] andType:type];
                [episodes addObject:episode];
            }
        else {
            episode = [self getEpisodeWithAnimeID:animeID episodeNumber:[NSNumber numberWithString:sequence] andType:type];
            if (!episode)
                episode = [self newEpisodeWithAnimeID:animeID episodeNumber:[NSNumber numberWithString:sequence] andType:type];
            [episodes addObject:episode];
        }
    return episodes;
}

- (void)callDelegatesWithManagedObject:(NSManagedObject *)managedObject {
    for (id<ADBPersistentConnectionDelegate> delegate in self.delegates) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate persistentConnection:self didReceiveResponse:managedObject];
        });
    }
}

- (BOOL)save:(NSError **)error {
    return [self.managedObjectContext save:error];
}

- (void)fetch:(NSManagedObject *)managedObject {
    if ([managedObject.entity.name isEqualToString:@"Anime"]) {
        Anime *anime = (Anime *)managedObject;
        unsigned short f = [anime.fetched unsignedShortValue];
        if (!(f & ADBAnimeFetchedAnime))
            [self sendRequest:[anime getRequest]];
    }
    if ([managedObject.entity.name isEqualToString:@"Character"]) {
        Character *character = (Character *)managedObject;
        if (![character.fetched boolValue])
            [self sendRequest:[character getRequest]];
    }
    if ([managedObject.entity.name isEqualToString:@"Creator"]) {
        Creator *creator = (Creator *)managedObject;
        if (![creator.fetched boolValue])
            [self sendRequest:[creator getRequest]];
    }
    if ([managedObject.entity.name isEqualToString:@"Episode"]) {
        Episode *episode = (Episode *)managedObject;
        if (![episode.fetched boolValue])
            [self sendRequest:[episode getRequest]];
    }
    if ([managedObject.entity.name isEqualToString:@"File"]) {
        File *file = (File *)managedObject;
        if (![file.fetched boolValue])
            [self sendRequest:[file getRequest]];
    }
    if ([managedObject.entity.name isEqualToString:@"Group"]) {
        Group *group = (Group *)managedObject;
        if (![group.fetched boolValue])
            [self sendRequest:[group getRequest]];
    }
}

- (Anime *)newAnimeWithID:(NSNumber *)animeID {
    return [self newAnimeWithID:animeID andFetch:NO];
}

- (Anime *)newAnimeWithID:(NSNumber *)animeID andFetch:(BOOL)fetch {
    Anime *temp;
    NSFetchRequest *request;
    NSError *error;
    NSArray *result;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Anime"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", animeID]];
    result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = [result objectAtIndex:0];
        else {
            temp = [[Anime alloc] initWithEntity:[NSEntityDescription entityForName:@"Anime" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setId:animeID];
        }
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    
    if (fetch && ![temp getFetchedBits:ADBAnimeFetchedAnime])
        [self sendRequest:[ADBRequest createAnimeWithID:animeID]];
    
    return temp;
}

- (Character *)newCharacterWithID:(NSNumber *)characterID {
    return [self newCharacterWithID:characterID andFetch:NO];
}

- (Character *)newCharacterWithID:(NSNumber *)characterID andFetch:(BOOL)fetch {
    Character *temp;
    NSFetchRequest *request;
    NSError *error;
    NSArray *result;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", characterID]];
    result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = [result objectAtIndex:0];
        else {
            temp = [[Character alloc] initWithEntity:[NSEntityDescription entityForName:@"Character" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setId:characterID];
        }
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    
    if (fetch && ![temp.fetched boolValue])
        [self sendRequest:[ADBRequest createCharacterWithID:characterID]];
    
    return temp;
}

- (Episode *)newEpisodeWithAnimeID:(NSNumber *)animeID episodeNumber:(NSNumber *)episodeNumber andType:(NSNumber *)type {
    return [self newEpisodeWithAnimeID:animeID episodeNumber:episodeNumber type:type andFetch:NO];
}

- (Episode *)newEpisodeWithAnimeID:(NSNumber *)animeID episodeNumber:(NSNumber *)episodeNumber type:(NSNumber *)type andFetch:(BOOL)fetch {
    Episode *temp = [[Episode alloc] initWithEntity:[NSEntityDescription entityForName:@"Episode" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
    [temp setAnime:[self newAnimeWithID:animeID]];
    [temp setEpisodeNumber:episodeNumber];
    [temp setType:type];
    return temp;
}

- (Episode *)newEpisodeWithID:(NSNumber *)episodeID {
    return [self newEpisodeWithID:episodeID andFetch:NO];
}

- (Episode *)newEpisodeWithID:(NSNumber *)episodeID andFetch:(BOOL)fetch {
    Episode *temp;
    NSFetchRequest *request;
    NSError *error;
    NSArray *result;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Episode"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", episodeID]];
    result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = [result objectAtIndex:0];
        else {
            temp = [[Episode alloc] initWithEntity:[NSEntityDescription entityForName:@"Episode" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setId:episodeID];
        }
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    
    if (fetch && ![temp.fetched boolValue])
        [self sendRequest:[ADBRequest createEpisodeWithID:episodeID]];
    
    return temp;
}

- (Episode *)getEpisodeWithAnimeID:(NSNumber *)animeID episodeNumber:(NSNumber *)episodeNumber andType:(NSNumber *)type {
    NSFetchRequest *request;
    NSError *error;
    NSArray *result;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Episode"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@ AND %K == %@", @"anime.id", animeID, @"episodeNumber", episodeNumber, @"type", type]];
    result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            return [result objectAtIndex:0];
        else
            return nil;
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    return nil;
}

- (Group *)newGroupWithID:(NSNumber *)groupID {
    return [self newGroupWithID:groupID andFetch:NO];
}

- (Group *)newGroupWithID:(NSNumber *)groupID andFetch:(BOOL)fetch {
    Group *temp;
    NSFetchRequest *request;
    NSError *error;
    NSArray *result;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Group"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", groupID]];
    result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = [result objectAtIndex:0];
        else {
            temp = [[Group alloc] initWithEntity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setId:groupID];
        }
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    
    if (fetch && ![temp.fetched boolValue])
        [self sendRequest:[ADBRequest createGroupWithID:groupID]];
    
    return temp;
}

- (Mylist *)newMylistWithID:(NSNumber *)mylistID {
    return [self newMylistWithID:mylistID andFetch:NO];
}

- (Mylist *)newMylistWithID:(NSNumber *)mylistID andFetch:(BOOL)fetch {
    Mylist *temp;
    NSFetchRequest *request;
    NSError *error;
    NSArray *result;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Mylist"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", mylistID]];
    result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = [result objectAtIndex:0];
        else {
            temp = [[Mylist alloc] initWithEntity:[NSEntityDescription entityForName:@"Mylist" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setId:mylistID];
        }
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    
    if (fetch && ![temp.fetched boolValue])
        [self sendRequest:[ADBRequest createMylistWithID:mylistID]];
    
    return temp;
}

- (Creator *)newCreatorWithID:(NSNumber *)creatorID {
    return [self newCreatorWithID:creatorID andFetch:NO];
}

- (Creator *)newCreatorWithID:(NSNumber *)creatorID andFetch:(BOOL)fetch {
    Creator *temp;
    NSFetchRequest *request;
    NSError *error;
    NSArray *result;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Creator"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", creatorID]];
    result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = [result objectAtIndex:0];
        else {
            temp = [[Creator alloc] initWithEntity:[NSEntityDescription entityForName:@"Creator" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setId:creatorID];
        }
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    
    if (fetch && ![temp.fetched boolValue])
        [self sendRequest:[ADBRequest createCreatorWithID:creatorID]];
    
    return temp;
}

- (File *)newFileWithID:(NSNumber *)fileID {
    return [self newFileWithID:fileID andFetch:NO];
}

- (File *)newFileWithID:(NSNumber *)fileID andFetch:(BOOL)fetch {
    File *temp;
    NSFetchRequest *request;
    NSError *error;
    NSArray *result;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"File"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", fileID]];
    result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = [result objectAtIndex:0];
        else {
            temp = [[File alloc] initWithEntity:[NSEntityDescription entityForName:@"File" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setId:fileID];
        }
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    
    if (fetch && ![temp.fetched boolValue])
        [self sendRequest:[ADBRequest createFileWithID:fileID]];
    
    return temp;
}

- (AnimeCategory *)newAnimeCategoryWithID:(NSNumber *)animeCategoryID {
    AnimeCategory *temp;
    NSFetchRequest *request;
    NSError *error;
    NSArray *result;
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"AnimeCategory"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", animeCategoryID]];
    result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        if ([result count] == 1)
            temp = [result objectAtIndex:0];
        else {
            temp = [[AnimeCategory alloc] initWithEntity:[NSEntityDescription entityForName:@"AnimeCategory" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
            [temp setValue:animeCategoryID forKey:@"id"];
        }
    } else
        NSLog(@"Error fetching data.\n%@, %@", error, error.localizedDescription);
    
    return temp;
}

- (void)invalidate:(NSManagedObject *)managedObject {
    if ([managedObject.entity.name isEqualToString:@"Episode"]) {
        [(Episode *)managedObject setFetched:@(-1)];
        [managedObject.managedObjectContext save:nil];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"type", [(Episode *)managedObject type]];
        NSSet *sameType = [[(Anime *)[managedObject valueForKey:@"anime"] episodes] filteredSetUsingPredicate:predicate];
        NSArray *episodes = [sameType sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"episodeNumber" ascending:YES]]];
        Episode *episode = [episodes objectAtIndex:[episodes count] - 1];
        [self newEpisodeWithAnimeID:[episode.anime valueForKey:@"id"] episodeNumber:[NSNumber numberWithLongLong:[episode.episodeNumber longLongValue] + 1] andType:episode.type];
    }
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "net.pipelynx.AniDBCoreData" in the user's Application Support directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AniDBCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"OSXCoreDataObjC.sqlite"];
        NSLog(@"Persistent store: %@", url);
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

@end
