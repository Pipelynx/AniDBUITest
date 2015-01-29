//
//  Mylist.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "DataClasses.h"


@implementation Mylist

@dynamic date;
@dynamic state;
@dynamic filestate;
@dynamic viewDate;
@dynamic storage;
@dynamic source;
@dynamic other;
@dynamic id;
@dynamic fetched;
@dynamic file;
@dynamic anime;
@dynamic episode;
@dynamic group;

- (NSString *)getRequest {
    return [ADBRequest createMylistWithID:self.id];
}

@end
