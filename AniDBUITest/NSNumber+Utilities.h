//
//  NSNumber+Utilities.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Utilities)

+ (NSNumber *)numberWithString:(NSString *)string;

- (NSComparisonResult)compareAppearanceTypes:(NSNumber *)otherNumber;

@end
