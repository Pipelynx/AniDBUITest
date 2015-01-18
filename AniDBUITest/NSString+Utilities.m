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

@end
