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

@property (nonatomic, strong, readonly) NSHashTable* delegates;

+ (ADBConnection *)sharedConnection;

- (void)addDelegate:(id<ADBConnectionDelegate>)delegate;
- (void)removeDelegate:(id<ADBConnectionDelegate>)delegate;

- (void)connect;

- (NSString *)getSessionKey;
- (NSString *)getImageServer;
- (BOOL)isLoggedIn;

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
- (void)logout;

- (void)sendRequest:(NSString *)request;

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