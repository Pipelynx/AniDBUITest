//
//  ADBConnection.h
//  ADBPrototype
//
//  Created by Martin Fellner on 08.12.14.
//  Copyright (c) 2014 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "ADBRequest.h"

@class ADBConnection;
@protocol ADBConnectionDelegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response;

@end

@interface ADBConnection : NSObject <GCDAsyncUdpSocketDelegate>

@property (nonatomic) float sendDelay; //In seconds
@property (nonatomic, readonly) BOOL isKeepingAlive;

@property (readonly, strong, nonatomic) NSHashTable* delegates;

#pragma mark - Setup

+ (ADBConnection *)sharedConnection;

- (void)addDelegate:(id<ADBConnectionDelegate>)delegate;
- (void)removeDelegate:(id<ADBConnectionDelegate>)delegate;

#pragma mark - Accessors

- (NSString *)getSessionKey;
- (NSURL *)getImageServer;
- (NSString *)getLastRequest;

#pragma mark - Authentication

- (BOOL)hasSession;
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)synchronousLoginWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)logout;

#pragma mark - Keep alive

- (void)startKeepAliveWithInterval:(NSTimeInterval)interval;
- (void)stopKeepAlive;
- (void)keepAlive;

#pragma mark - Sending

- (BOOL)sendRequest:(NSString *)request;
- (NSDictionary *)sendRequest:(NSString *)request synchronouslyWithTimeout:(uint)timeout;

#pragma mark - Parsing

- (void)parse:(NSString *)response;
- (void)callDelegatesWithDictionary:(NSDictionary *)responseDictionary;
- (NSDictionary *)parseResponse:(NSString *)response;
- (NSDictionary *)parseAnime:(NSString *)valueString forMask:(unsigned long long)mask;
- (NSDictionary *)parseCharacter:(NSString *)valueString;
- (NSDictionary *)parseCreator:(NSString *)valueString;
- (NSDictionary *)parseEpisode:(NSString *)valueString;
- (NSDictionary *)parseFile:(NSString *)valueString forFileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask;
- (NSDictionary *)parseGroup:(NSString *)valueString;

@end