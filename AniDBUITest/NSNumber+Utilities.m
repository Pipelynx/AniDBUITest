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

- (NSComparisonResult)compareAppearanceTypes:(NSNumber *)otherNumber {
    NSNumber *n1 = @-1;
    NSNumber *n2 = @-1;
    switch ([self intValue]) {
        case 2: n1 = @0; break;
        case 3: n1 = @1; break;
        case 1: n1 = @2; break;
        case 0: n1 = @3; break;
    }
    switch ([otherNumber intValue]) {
        case 2: n2 = @0; break;
        case 3: n2 = @1; break;
        case 1: n2 = @2; break;
        case 0: n2 = @3; break;
    }
    return [n1 compare:n2];
}

@end
