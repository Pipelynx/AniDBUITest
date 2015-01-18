//
//  Creator.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ADBRequest.h"


@interface Creator : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * fetched;
@property (nonatomic, retain) NSString * kanjiName;
@property (nonatomic, retain) NSString * romajiName;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * urlEnglish;
@property (nonatomic, retain) NSString * urlJapanese;
@property (nonatomic, retain) NSString * wikiEnglish;
@property (nonatomic, retain) NSString * wikiJapanese;
@property (nonatomic, retain) NSDate * recordUpdated;
@property (nonatomic, retain) NSManagedObject *characters;

- (NSString *)getRequest;

@end
