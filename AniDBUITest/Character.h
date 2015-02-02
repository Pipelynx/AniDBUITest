//
//  Character.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


typedef enum {
    ADBCharacterAppearanceTypeAppears = 0,
    ADBCharacterAppearanceTypeCameoAppearance = 1,
    ADBCharacterAppearanceTypeMainCharacter = 2,
    ADBCharacterAppearanceTypeSecondaryCharacter = 3
} ADBCharacterAppearanceType;

@class Anime, Creator;

@interface Character : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * fetched;
@property (nonatomic, retain) NSNumber * fetching;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * kanjiName;
@property (nonatomic, retain) NSDate * recordUpdated;
@property (nonatomic, retain) NSString * romajiName;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *characterInfos;

- (NSString *)getRequest;
- (NSURL *)getImageURLWithServer:(NSURL *)imageServer;

- (NSManagedObject *)addCharacterInfoWithAnime:(Anime *)anime creator:(Creator *)creator appearanceType:(NSNumber *)appearanceType andIsMainSeiyuu:(NSNumber *)isMainSeiyuu;

@end

@interface Character (CoreDataGeneratedAccessors)

- (void)addCharacterInfosObject:(NSManagedObject *)value;
- (void)removeCharacterInfosObject:(NSManagedObject *)value;
- (void)addCharacterInfos:(NSSet *)values;
- (void)removeCharacterInfos:(NSSet *)values;

@end
