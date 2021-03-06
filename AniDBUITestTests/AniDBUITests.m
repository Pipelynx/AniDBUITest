//
//  AniDBUITests.m
//  AniDBUITests
//
//  Created by Martin Fellner on 16.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ADBPersistentConnection.h"

@interface AniDBUITests : XCTestCase

@property (strong, nonatomic) ADBConnection *anidb;

@end

@implementation AniDBUITests

- (void)setUp {
    [super setUp];
    self.anidb = [ADBConnection sharedConnection];
    if (!self.anidb.hasSession)
        [self.anidb synchronousLoginWithUsername:@"pipelynx" andPassword:@"Swc5gzFPAjn985GjnD3z"];
}

- (void)tearDown {
    /*if (self.anidb.hasSession)
     [self.anidb synchronousLogout];*/
    [super tearDown];
}

- (void)testAnime {
    NSDictionary *result = [self.anidb sendRequest:[ADBRequest requestAnimeWithID:@69 andMask:AM_FULL] synchronouslyWithTimeout:0];
    if (![result[@"romajiName"] isEqualToString:@"One Piece"])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestAnimeWithName:@"Sword Art Online" andMask:AM_FULL] synchronouslyWithTimeout:0];
    if (![result[@"id"] isEqualToString:@"8692"])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestAnimeWithName:@"Sword Art Online 14" andMask:AM_FULL] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeNoSuchAnime])
        XCTAssert(NO);
    XCTAssert(YES);
}

- (void)testRandomAnime {
    NSDictionary *result = [self.anidb sendRequest:[ADBRequest requestRandomAnimeWithType:ADBRandomAnimeTypeAniDB] synchronouslyWithTimeout:0];
    XCTAssert(result[@"id"] != nil);
}

- (void)testUser {
    NSDictionary *result = [self.anidb sendRequest:[ADBRequest requestUserWithID:@321067] synchronouslyWithTimeout:0];
    if (![result[@"username"] isEqualToString:@"pipelynx"])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestUserWithID:@1000000] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeNoSuchUser])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestUserWithName:@"pipelynx"] synchronouslyWithTimeout:0];
    if (![result[@"id"] isEqualToString:@"321067"])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestUserWithName:@"pipelynxx"] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeNoSuchUser])
        XCTAssert(NO);
    XCTAssert(YES);
}

- (void)testMylistExport {
    NSDictionary *result = [self.anidb sendRequest:[ADBRequest requestMylistExportWithTemplate:@"csv"] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeExportNoSuchTemplate])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestMylistExportWithTemplate:@"csv-minimal"] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeExportQueued])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestMylistExportWithTemplate:@"csv-files"] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeExportAlreadyInQueue])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestMylistExportCancel] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeExportCancelled])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestMylistExportCancel] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeExportNoExportQueuedOrIsProcessing])
        XCTAssert(NO);
    XCTAssert(YES);
}

- (void)testSendMessage {
    NSDictionary *result = [self.anidb sendRequest:[ADBRequest requestSendMessageWithTitle:@"This is a title" andBody:@"This is the body of the message" toUser:@"pipelynx"] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeSendMessageSuccessful])
        XCTAssert(NO);
    result = [self.anidb sendRequest:[ADBRequest requestSendMessageWithTitle:@"This is a title" andBody:@"This is the body of the message" toUser:@"pipelynxx"] synchronouslyWithTimeout:0];
    if (![result hasResponseCode:ADBResponseCodeNoSuchUser])
        XCTAssert(NO);
    XCTAssert(YES);
}

- (void)testVersion {
    NSDictionary *result = [self.anidb sendRequest:[ADBRequest requestVersion] synchronouslyWithTimeout:0];
    XCTAssert(result[@"version"] != nil);
}

- (void)testUptime {
    NSDictionary *result = [self.anidb sendRequest:[ADBRequest requestUptime] synchronouslyWithTimeout:0];
    XCTAssert([result[@"uptime"] integerValue] > 0);
}

@end

@interface AniDBUIPersistentTests : XCTestCase

@property (strong, nonatomic) ADBPersistentConnection *anidb;

@end

@implementation AniDBUIPersistentTests

- (void)setUp {
    [super setUp];
    self.anidb = [ADBPersistentConnection sharedConnection];
    if (!self.anidb.hasSession)
        [self.anidb synchronousLoginWithUsername:@"pipelynx" andPassword:@"Swc5gzFPAjn985GjnD3z"];
}

- (void)tearDown {
    /*if (self.anidb.hasSession)
     [self.anidb synchronousLogout];*/
    [super tearDown];
}

- (void)testGroupStatusEmpty {
    Anime *result = [self.anidb sendRequest:[ADBRequest requestGroupStatusWithAnimeID:@10181 andState:ADBGroupStatusSpecialsOnly] synchronouslyWithTimeout:0];
    XCTAssert([result hasNoGroupStatusForState:ADBGroupStatusSpecialsOnly]);
}

@end
