//
//  NSDictionary+Anidb.m
//  AniDBUITest
//
//  Created by Martin Fellner on 02.02.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "NSDictionary+Anidb.h"

@implementation NSDictionary (Anidb)

- (BOOL)hasResponseCode:(int)responseCode {
    if (![self objectForKey:@"responseType"])
        return NO;
    return [[self objectForKey:@"responseType"] intValue] == responseCode;
}

@end
