//
//  Mylist.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ADBRequest.h"

@class Anime, Episode, File, Group;

@interface Mylist : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * filestate;
@property (nonatomic, retain) NSString * viewDate;
@property (nonatomic, retain) NSString * storage;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * other;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * fetched;
@property (nonatomic, retain) File *file;
@property (nonatomic, retain) Anime *anime;
@property (nonatomic, retain) Episode *episode;
@property (nonatomic, retain) Group *group;

- (NSString *)getRequest;

@end
