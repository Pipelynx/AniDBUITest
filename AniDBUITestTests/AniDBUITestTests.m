//
//  AniDBUITestTests.m
//  AniDBUITestTests
//
//  Created by Martin Fellner on 16.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ADBConnection.h"

@interface AniDBUITestTests : XCTestCase

@property (strong, nonatomic) ADBConnection *anidb;

@end

@implementation AniDBUITestTests

- (void)setUp {
    [super setUp];
    self.anidb = [ADBConnection sharedConnection];
    if (![self.anidb hasSession])
        [self.anidb synchronousLoginWithUsername:@"pipelynx" andPassword:@"Swc5gzFPAjn985GjnD3z"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSynchronousRequest {
    NSLog(@"!");
    NSLog(@"%@", [self.anidb sendRequest:[ADBRequest requestPingWithNAT:YES] synchronouslyWithTimeout:0]);
}

@end
