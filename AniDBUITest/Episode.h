//
//  Episode.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
    ADBEpisodeTypeNormal = 1,
    ADBEpisodeTypeSpecial = 2,
    ADBEpisodeTypeCredits = 3,
    ADBEpisodeTypeTrailer = 4,
    ADBEpisodeTypeParody = 5,
    ADBEpisodeTypeOther = 6
} ADBEpisodeType;

@interface Episode : NSManagedObject

@property (nonatomic, retain) NSDate * airDate;
@property (nonatomic, retain) NSString * englishName;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * episodeNumber;
@property (nonatomic, retain) NSNumber * fetched;
@property (nonatomic, retain) NSString * kanjiName;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * ratingCount;
@property (nonatomic, retain) NSString * romajiName;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSManagedObject *anime;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) NSSet *mylists;
@property (nonatomic, retain) NSSet *otherFiles;

- (NSString *)getRequest;
- (NSString *)getRequestByNumber;

- (NSString *)getEpisodeNumberString;

+ (NSNumber *)getTypeFromEpisodeNumberString:(NSString *)episodeNumberString;
+ (NSNumber *)getEpisodeNumberFromEpisodeNumberString:(NSString *)episodeNumberString;

@end

@interface Episode (CoreDataGeneratedAccessors)

- (void)addFilesObject:(NSManagedObject *)value;
- (void)removeFilesObject:(NSManagedObject *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

- (void)addMylistsObject:(NSManagedObject *)value;
- (void)removeMylistsObject:(NSManagedObject *)value;
- (void)addMylists:(NSSet *)values;
- (void)removeMylists:(NSSet *)values;

- (void)addOtherFilesObject:(NSManagedObject *)value;
- (void)removeOtherFilesObject:(NSManagedObject *)value;
- (void)addOtherFiles:(NSSet *)values;
- (void)removeOtherFiles:(NSSet *)values;

@end
