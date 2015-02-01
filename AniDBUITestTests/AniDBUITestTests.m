//
//  AniDBUITestTests.m
//  AniDBUITestTests
//
//  Created by Martin Fellner on 16.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ADBRequest.h"

@interface AniDBUITestTests : XCTestCase

@end

@implementation AniDBUITestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMylistRequest {
    NSDictionary *parameters = [ADBRequest parameterDictionaryWithState:1 viewed:NO viewDate:[NSDate dateWithTimeIntervalSince1970:0] source:@"Internet" storage:@"Agnes" andOther:@"Hi, where am I?"];
    NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",
          [ADBRequest requestMylistAddWithFileID:@1234 andParameters:parameters],
          [ADBRequest requestMylistAddWithSize:1234567 ed2k:@"1234567890abcdef" andParameters:parameters],
          [ADBRequest requestMylistAddWithAnimeID:@34567 genericGroupEpisodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistAddWithAnimeID:@34567 groupID:@456 episodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistAddWithAnimeID:@34567 groupName:@"group" episodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistAddWithAnimeName:@"anime" genericGroupEpisodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistAddWithAnimeName:@"anime" groupID:@456 episodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistAddWithAnimeName:@"anime" groupName:@"group" episodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistEditWithMylistID:@2345 andParameters:parameters],
          [ADBRequest requestMylistEditWithFileID:@1234 andParameters:parameters],
          [ADBRequest requestMylistEditWithSize:1234567 ed2k:@"1234567890abcdef" andParameters:parameters],
          [ADBRequest requestMylistEditWithAnimeID:@34567 genericGroupEpisodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistEditWithAnimeID:@34567 groupID:@456 episodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistEditWithAnimeID:@34567 groupName:@"group" episodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistEditWithAnimeName:@"anime" genericGroupEpisodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistEditWithAnimeName:@"anime" groupID:@456 episodeRange:@"1-5" andParameters:parameters],
          [ADBRequest requestMylistEditWithAnimeName:@"anime" groupName:@"group" episodeRange:@"1-5" andParameters:parameters]);
}

@end
