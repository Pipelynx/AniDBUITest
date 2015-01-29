//
//  NSString+Utilities.m
//  AniDBTestSuite
//
//  Created by Martin Fellner on 11.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString *)stringByPaddingLeftwithPattern:(NSString *)pattern {
    if ([pattern length] < [self length])
        return self;
    else {
        return [[pattern substringToIndex:([pattern length] - [self length])] stringByAppendingString:self];
    }
}

- (NSString *)extractRequestAttribute:(NSString *)attribute {
    NSRange range = [self rangeOfString:[NSString stringWithFormat:@" %@=", attribute]];
    if (range.location == NSNotFound) {
        range = [self rangeOfString:[NSString stringWithFormat:@"&%@=", attribute]];
        if (range.location == NSNotFound)
            return nil;
    }
    unsigned long from = range.location + range.length;
    range = [[self substringFromIndex:from] rangeOfString:@"&"];
    if (range.location == NSNotFound)
        return [self substringFromIndex:from];
    else
        return [self substringWithRange:NSMakeRange(from, range.location)];
}

@end
