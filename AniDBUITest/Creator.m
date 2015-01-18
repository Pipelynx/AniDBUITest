//
//  Creator.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "Creator.h"


@implementation Creator

@dynamic id;
@dynamic fetched;
@dynamic kanjiName;
@dynamic romajiName;
@dynamic type;
@dynamic imageName;
@dynamic urlEnglish;
@dynamic urlJapanese;
@dynamic wikiEnglish;
@dynamic wikiJapanese;
@dynamic recordUpdated;
@dynamic characters;

- (NSString *)getRequest {
    return [ADBRequest createGroupWithID:self.id];
}

@end
