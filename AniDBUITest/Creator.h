//
//  Creator.h
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Anime;

@interface Creator : NSManagedObject

@property (nonatomic, retain) NSNumber * fetched;
@property (nonatomic, retain) NSNumber * fetching;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * kanjiName;
@property (nonatomic, retain) NSDate * recordUpdated;
@property (nonatomic, retain) NSString * romajiName;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * urlEnglish;
@property (nonatomic, retain) NSString * urlJapanese;
@property (nonatomic, retain) NSString * wikiEnglish;
@property (nonatomic, retain) NSString * wikiJapanese;
@property (nonatomic, retain) NSSet *creatorInfos;
@property (nonatomic, retain) NSSet *characters;

@property (nonatomic, readonly) NSString *typeString;

- (NSString *)getRequest;

- (NSURL *)getImageURLWithServer:(NSURL *)imageServer;

- (NSManagedObject *)addCreatorInfoWithAnime:(Anime *)anime isMainCreator:(NSNumber *)isMainCreator;

@end

@interface Creator (CoreDataGeneratedAccessors)

- (void)addCreatorInfosObject:(NSManagedObject *)value;
- (void)removeCreatorInfosObject:(NSManagedObject *)value;
- (void)addCreatorInfos:(NSSet *)values;
- (void)removeCreatorInfos:(NSSet *)values;

- (void)addCharactersObject:(NSManagedObject *)value;
- (void)removeCharactersObject:(NSManagedObject *)value;
- (void)addCharacters:(NSSet *)values;
- (void)removeCharacters:(NSSet *)values;

@end
