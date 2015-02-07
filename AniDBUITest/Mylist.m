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
@dynamic fetching;
@dynamic file;
@dynamic anime;
@dynamic episode;
@dynamic group;

- (NSString *)stateString {
    switch ([self.state intValue]) {
        case 0: return @"Unknown";
        case 1: return @"On HDD";
        case 2: return @"On CD";
        case 3: return @"Deleted";
        default: return nil;
    }
}

- (NSString *)request {
    if ([self.id isEqualToNumber:@0])
        return [self requestByFile];
    else
        return [ADBRequest requestMylistWithID:self.id];
}

- (NSString *)requestByFile {
    return [ADBRequest requestMylistWithFileID:self.file.id];
}

@end
