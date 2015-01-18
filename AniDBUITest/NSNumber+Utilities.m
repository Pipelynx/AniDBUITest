//
//  NSNumber+Utilities.m
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "NSNumber+Utilities.h"

@implementation NSNumber (Utilities)

+ (NSNumber *)numberWithString:(NSString *)string {
    return [self numberWithLongLong:[string longLongValue]];
}

@end
