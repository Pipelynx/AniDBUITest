//
//  ADBConnection.m
//  ADBPrototype
//
//  Created by Martin Fellner on 08.12.14.
//  Copyright (c) 2014 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBConnection.h"

#define HOST @"api.anidb.net"
#define PORT 9000

#define ANIME_FIELDS [NSArray arrayWithObjects:@"id", @"dateFlags", @"yearRange", @"type", @"relatedAnimeIDList", @"relatedAnimeTypeList", @"categoryNameList", @"categoryWeightList", @"romajiName", @"kanjiName", @"englishName", @"otherNameList", @"shortNameList", @"synonymList", @"retired", @"retired", @"numberOfEpisodes", @"highestEpisodeNumber", @"numberOfSpecialEpisodes", @"airDate", @"endDate", @"url", @"imageName", @"categoryIDList", @"rating", @"ratingCount", @"tempRating", @"tempRatingCount", @"reviewRating", @"reviewCount", @"awardList", @"restrict18", @"animePlanetID", @"annID", @"allcinemaID", @"animeNfoID", @"unused", @"unused", @"unused", @"recordUpdated", @"characterIDList", @"creatorIDList", @"mainCreatorIDList", @"mainCreatorNameList", @"unused", @"unused", @"unused", @"unused", @"numberOfSpecials", @"numberOfCredits", @"numberOfOthers", @"numberOfTrailers", @"numberOfParodies", @"unused", @"unused", @"unused", nil]
#define ANIME_KOMMA_KEYS [NSArray arrayWithObjects:@"categoryIDList", @"categoryNameList", @"categoryWeightList", @"characterIDList", @"creatorIDList", @"mainCreatorIDList", @"mainCreatorNameList", nil]
#define ANIME_APOSTROPHE_KEYS [NSArray arrayWithObjects:@"relatedAnimeIDList", @"relatedAnimeTypeList", @"otherNameList", @"shortNameList", @"synonymList", nil]

#define CHARACTER_FIELDS [NSArray arrayWithObjects:@"id", @"kanjiName", @"romajiName", @"imageName", @"animeBlocks", @"episodeList", @"recordUpdated", @"type", @"gender", nil]
#define CHARACTER_BLOCK_KEYS [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"animeID", @"appearanceType", @"creatorID", @"isMainSeiyuu", nil], @"animeBlocks", nil]

#define CREATOR_FIELDS [NSArray arrayWithObjects:@"id", @"kanjiName", @"romajiName", @"type", @"imageName", @"urlEnglish", @"urlJapanese", @"wikiEnglish", @"wikiJapanese", @"recordUpdated", nil]

#define EPISODE_FIELDS [NSArray arrayWithObjects:@"id", @"animeID", @"length", @"rating", @"ratingCount", @"episodeNumber", @"englishName", @"romajiName", @"kanjiName", @"airDate", @"type", nil]

#define FILE_FIELDS [NSArray arrayWithObjects:@"id", @"animeID", @"episodeID", @"groupID", @"mylistID", @"otherEpisodeList", @"deprecated", @"state", @"size", @"ed2k", @"md5", @"sha1", @"crc32", @"unused", @"videoColourDepth", @"reserved", @"quality", @"source", @"audioCodecList", @"audioBitrateList", @"videoCodec", @"videoBitrate", @"videoResolution", @"fileExtension", @"dubLanguage", @"subLanguage", @"length", @"fileDescription", @"airDate", @"unused", @"unused", @"aniDBFilename", @"mylistState", @"mylistFilestate", @"mylistViewed", @"mylistViewDate", @"mylistStorage", @"mylistSource", @"mylistOther", @"unused", @"numberOfEpisodes", @"highestEpisodeNumber", @"yearRange", @"type", @"relatedAnimeIDList", @"relatedAnimeTypeList", @"categoryNameList", @"reserved", @"romajiName", @"kanjiName", @"englishName", @"otherNameList", @"shortNameList", @"synonymList", @"retired", @"retired", @"episodeNumber", @"episodeEnglishName", @"episodeRomajiName", @"episodeKanjiName", @"episodeRating", @"episodeRatingCount", @"unused", @"unused", @"groupName", @"groupShortName", @"unused", @"unused", @"unused", @"unused", @"unused", @"recordUpdated", nil]
#define FILE_KOMMA_KEYS [NSArray arrayWithObjects:@"categoryNameList", nil]
#define FILE_APOSTROPHE_KEYS [NSArray arrayWithObjects:@"audioCodecList", @"audioBitrateList", @"relatedAnimeIDList", @"relatedAnimeTypeList", @"dubLanguage", @"subLanguage", nil]

#define GROUP_FIELDS [NSArray arrayWithObjects:@"id", @"rating", @"ratingCount", @"animeCount", @"fileCount", @"name", @"shortName", @"ircChannel", @"ircServer", @"url", @"imageName", @"founded", @"disbanded", @"dateflags", @"lastRelease", @"lastActivity", @"relations", nil]
#define GROUP_BLOCK_KEYS [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"groupID", @"type", nil], @"relations", nil]

#define GROUPSTATUS_FIELDS [NSArray arrayWithObjects:@"name", @"completionState", @"lastEpisodeNumber", @"rating", @"ratingCount", @"episodeRange", nil]

#define MYLIST_FIELDS [NSArray arrayWithObjects:@"id", @"fileID", @"episodeID", @"animeID", @"groupID", @"date", @"state", @"viewDate", @"storage", @"source", @"other", @"filestate", nil]

@interface ADBConnection ()

@property (strong, nonatomic) dispatch_queue_t requestQueue;
@property (strong, nonatomic) dispatch_queue_t responseQueue;
@property (strong, nonatomic) GCDAsyncUdpSocket *socket;
@property (strong, nonatomic) NSHashTable* delegates;

@property (strong, nonatomic) NSString *s;
@property (strong, nonatomic) NSString *imageServer;
@property (nonatomic) BOOL triedLogin;
@property (nonatomic) UIBackgroundTaskIdentifier task;

@end

@implementation ADBConnection

static NSString *lastRequest = nil;

#pragma mark - Setup

+ (ADBConnection *)sharedConnection {
    static ADBConnection *sharedConnection = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{ sharedConnection = [[self alloc] init]; });
    return sharedConnection;
}

- (id)init {
    if (self = [super init]) {
        _requestQueue = dispatch_queue_create("Request queue", NULL);
        _responseQueue = dispatch_queue_create("Response queue", NULL);
        _socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("Socket queue", NULL)];
        _delegates = [NSHashTable weakObjectsHashTable];
        _s = @"";
        _triedLogin = NO;
        _sendDelay = 40;
        _task = 0;
        
        NSError *error = nil;
        if (![self.socket connectToHost:HOST onPort:PORT error:&error])
            NSLog(@"Error trying to connect: %@", error);
        error = nil;
        if (![self.socket beginReceiving:&error])
            NSLog(@"Error trying to begin receiving: %@", error);
    }
    return self;
}

- (void)addDelegate:(id<ADBConnectionDelegate>)delegate
{
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id<ADBConnectionDelegate>)delegate
{
    [self.delegates removeObject:delegate];
}

#pragma mark - Accessors

- (NSString *)getSessionKey {
    return self.s;
}

- (NSURL *)getImageServer {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.imageServer]];
}

- (NSString *)getLastRequest {
    return lastRequest;
}

#pragma mark - Authentication

- (BOOL)isLoggedIn {
    return !([self.s isEqualToString:@""]);
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    if (!self.triedLogin)
        [self sendRequest:[ADBRequest requestAuthWithUsername:username password:password version:3 client:@"nijikon" clientVersion:1 NAT:TRUE compression:FALSE encoding:@"UTF8" MTU:1400 andImageServer:TRUE]];
}

- (void)blockingLoginWithUsername:(NSString *)username andPassword:(NSString *)password {
    [self loginWithUsername:username andPassword:password];
    [self waitForLogin];
}

- (BOOL)waitForLogin {
    while (self.triedLogin)
        usleep(1000);
    return self.isLoggedIn;
}

- (void)logout {
    [self sendRequest:[ADBRequest requestLogout]];
}

- (void)logoutWithBackgroundTask:(UIBackgroundTaskIdentifier)task {
    [self setTask:task];
    [self logout];
}

#pragma mark - Sending

- (void)sendRequest:(NSString *)request {
    NSString* toSend;
    if ([request hasPrefix:@"PING"])
        toSend = request;
    else
        if ([request hasPrefix:@"AUTH"]) {
            self.triedLogin = YES;
            toSend = request;
        }
        else {
            if (![self waitForLogin])
                return;
            toSend = [request stringByAppendingString:self.s];
        }
    
    dispatch_async(self.requestQueue, ^{
        NSLog(@"Sending:\n%@", toSend);
        if ([lastRequest isEqualToString:toSend]) {
            NSLog(@"Trying to send same request again, dropped");
        }
        else {
            lastRequest = toSend;
            [self.socket sendData:[toSend dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1.0 tag:0];
            usleep(100000 * self.sendDelay);
        }
    });
}

#pragma mark - Parsing

- (void)parse:(NSString *)response {
    [self callDelegatesWithDictionary:[self parseResponse:response]];
}

- (void)callDelegatesWithDictionary:(NSDictionary *)responseDictionary {
    for (id<ADBConnectionDelegate> delegate in self.delegates) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate connection:self didReceiveResponse:responseDictionary];
        });
    }
}

- (NSDictionary *)parseResponse:(NSString *)response {
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    [temp setValue:lastRequest forKey:@"request"];
    if ([lastRequest hasPrefix:@"AUTH"])
        self.triedLogin = NO;
    lastRequest = nil;
    
    NSArray *lines = [response componentsSeparatedByString:@"\n"];
    NSArray *firstLine = [[lines objectAtIndex:0] componentsSeparatedByString:@" "];
    
    unsigned long long mask = 0;
    unsigned long long animeMask = 0;
    int code = 0;
    
    if ([[firstLine objectAtIndex:0] length] > 3) {
        [temp setValue:[firstLine objectAtIndex:1] forKey:@"responseType"];
        [temp setValue:[firstLine objectAtIndex:0] forKey:@"tag"];
    }
    else
        [temp setValue:[firstLine objectAtIndex:0] forKey:@"responseType"];
    code = [temp[@"responseType"] intValue];
    
    switch (code) {
        case ADBResponseCodeLoginAcceptedNewVersion:
        case ADBResponseCodeLoginAccepted:
            [temp setValue:[firstLine objectAtIndex:1] forKey:@"sessionKey"];
            [temp setValue:[firstLine objectAtIndex:2] forKey:@"ownIP"];
            [temp setValue:[lines objectAtIndex:1] forKey:@"imageServer"];
            self.s = temp[@"sessionKey"];
            self.imageServer = temp[@"imageServer"];
            break;
        case ADBResponseCodeLoginFailed:
            NSLog(@"Login failed");
            break;
        case ADBResponseCodeLoggedOut:
            NSLog(@"Logged out");
            break;
        case ADBResponseCodeAnime:
            [[NSScanner scannerWithString:temp[@"tag"]] scanHexLongLong:&mask];
            [temp addEntriesFromDictionary:[self parseAnime:[lines objectAtIndex:1] forMask:mask]];
            [self parse:&temp forKommas:ANIME_KOMMA_KEYS apostrophes:ANIME_APOSTROPHE_KEYS andBlocks:nil];
            break;
            
        case ADBResponseCodeNoSuchAnime:
            NSLog(@"No such anime");
            break;
            
        case ADBResponseCodeCharacter:
            [temp addEntriesFromDictionary:[self parseCharacter:[lines objectAtIndex:1]]];
            [self parse:&temp forKommas:nil apostrophes:nil andBlocks:CHARACTER_BLOCK_KEYS];
            break;
            
        case ADBResponseCodeNoSuchCharacter:
            NSLog(@"No such character");
            break;
            
        case ADBResponseCodeCreator:
            [temp addEntriesFromDictionary:[self parseCreator:[lines objectAtIndex:1]]];
            break;
            
        case ADBResponseCodeNoSuchCreator:
            NSLog(@"No such creator");
            break;
            
        case ADBResponseCodeEpisode:
            [temp addEntriesFromDictionary:[self parseEpisode:[lines objectAtIndex:1]]];
            break;
            
        case ADBResponseCodeNoSuchEpisode:
            NSLog(@"No such episode");
            break;
            
        case ADBResponseCodeFile:
            [[NSScanner scannerWithString:[[temp[@"tag"] componentsSeparatedByString:@":"] objectAtIndex:0]] scanHexLongLong:&mask];
            [[NSScanner scannerWithString:[[temp[@"tag"] componentsSeparatedByString:@":"] objectAtIndex:1]] scanHexLongLong:&animeMask];
            [temp addEntriesFromDictionary:[self parseFile:[lines objectAtIndex:1] forFileMask:mask andAnimeMask:animeMask]];
            [self parse:&temp forKommas:FILE_KOMMA_KEYS apostrophes:FILE_APOSTROPHE_KEYS andBlocks:nil];
            break;
            
        case ADBResponseCodeMultipleFilesFound:
            [temp setValue:[[lines objectAtIndex:1] componentsSeparatedByString:@"|"] forKey:@"fileIDs"];
            break;
            
        case ADBResponseCodeNoSuchFile:
            NSLog(@"No such file");
            break;
            
        case ADBResponseCodeGroup:
            [temp addEntriesFromDictionary:[self parseGroup:[lines objectAtIndex:1]]];
            [self parse:&temp forKommas:nil apostrophes:nil andBlocks:GROUP_BLOCK_KEYS];
            break;
            
        case ADBResponseCodeNoSuchGroup:
            NSLog(@"No such group");
            break;
            
        case ADBResponseCodeGroupStatus:
            [temp setValue:[self parseGroupStatus:lines] forKey:@"groups"];
            break;
            
        case ADBResponseCodeNoSuchGroupsFound:
            NSLog(@"No such groups found");
            break;
            
        case ADBResponseCodeBanned:
            @throw [NSException exceptionWithName:@"Banned" reason:@"Banned by AniDB" userInfo:nil];
            break;
            
        case ADBResponseCodePong: {
            NSString *nat = [temp[@"request"] extractRequestAttribute:@"nat"];
            if (nat)
                if ([nat intValue] > 0)
                    [temp setValue:lines[1] forKey:@"port"];
            NSLog(@"PONG: %@", lines[1]);
            break;
        }
            
        default:
            NSLog(@"No response case applied:\n%@", response);
            break;
    }
    if (self.task != 0) {
        [[UIApplication sharedApplication] endBackgroundTask:self.task];
        [self setTask:0];
    }
    return temp;
}

- (NSDictionary *)parseAnime:(NSString *)valueString forMask:(unsigned long long)mask {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *keys = ANIME_FIELDS;
    NSArray *values = [valueString componentsSeparatedByString:@"|"];
    
    uint i = (uint)[values count] - 1;
    uint j = (uint)[keys count] - 1;
    while (mask > 0) {
        if (mask & 1) {
            [dict setValue:[values objectAtIndex:i] forKey:[keys objectAtIndex:j]];
            i--;
        }
        j--;
        mask >>= 1;
    }
    return dict;
}

- (NSDictionary *)parseCharacter:(NSString *)valueString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *values = [valueString componentsSeparatedByString:@"|"];
    [dict setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:values forKeys:CHARACTER_FIELDS]];
    return dict;
}

- (NSDictionary *)parseCreator:(NSString *)valueString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *values = [valueString componentsSeparatedByString:@"|"];
    [dict setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:values forKeys:CREATOR_FIELDS]];
    return dict;
}

- (NSDictionary *)parseEpisode:(NSString *)valueString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *values = [valueString componentsSeparatedByString:@"|"];
    [dict setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:values forKeys:EPISODE_FIELDS]];
    return dict;
}

- (NSDictionary *)parseFile:(NSString *)valueString forFileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *keys = FILE_FIELDS;
    NSArray *values = [valueString componentsSeparatedByString:@"|"];
    [dict setValue:[values objectAtIndex:0] forKey:@"id"];
    
    uint i = (uint)[values count] - 1;
    uint j = (uint)[keys count] - 1;
    while (animeMask > 0) {
        if (animeMask & 1) {
            [dict setValue:[values objectAtIndex:i] forKey:[keys objectAtIndex:j]];
            i--;
        }
        j--;
        animeMask >>= 1;
    }
    while (fileMask > 0) {
        if (fileMask & 1) {
            [dict setValue:[values objectAtIndex:i] forKey:[keys objectAtIndex:j]];
            i--;
        }
        j--;
        fileMask >>= 1;
    }
    return dict;
}

- (NSDictionary *)parseGroup:(NSString *)valueString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *values = [valueString componentsSeparatedByString:@"|"];
    [dict setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:values forKeys:GROUP_FIELDS]];
    return dict;
}

- (NSDictionary *)parseGroupStatus:(NSArray *)valueStrings {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *values;
    //start with second line because of response code
    for (int i = 1; i < [valueStrings count]; i++) {
        if (![valueStrings[i] isEqualToString:@""]) {
            values = [valueStrings[i] componentsSeparatedByString:@"|"];
            [dict setValue:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:values[1], values[2], values[3], values[4], values[5], values[6], nil] forKeys:GROUPSTATUS_FIELDS] forKey:values[0]];
        }
    }
    return dict;
}

- (void)parse:(NSDictionary **)dict forKommas:(NSArray *)kommaKeys apostrophes:(NSArray *)apostropheKeys andBlocks:(NSDictionary *)blockDict {
    /*NSMutableArray *temp;
    NSString *value;
    NSArray *blockKeys;
    NSArray *blocks;
    if (kommaKeys)
        for (int i = 0; i < [kommaKeys count]; i++)
            if ([*dict valueForKey:[kommaKeys objectAtIndex:i]])
                [*dict setValue:[[*dict valueForKey:[kommaKeys objectAtIndex:i]] componentsSeparatedByString:@","] forKey:[kommaKeys objectAtIndex:i]];
    if (apostropheKeys)
        for (int i = 0; i < [apostropheKeys count]; i++)
            if ([*dict valueForKey:[apostropheKeys objectAtIndex:i]])
                [*dict setValue:[[*dict valueForKey:[apostropheKeys objectAtIndex:i]] componentsSeparatedByString:@"'"] forKey:[apostropheKeys objectAtIndex:i]];
    if (blockDict) {
        blockKeys = [blockDict allKeys];
        for (int i = 0; i < [blockKeys count]; i++) {
            temp = [NSMutableArray array];
            value = [*dict valueForKey:[blockKeys objectAtIndex:i]];
            if (![value isEqualToString:@""]) {
                blocks = [value componentsSeparatedByString:@"'"];
                for (int j = 0; j < [blocks count]; j++) {
                    [temp addObject:[NSDictionary dictionaryWithObjects:[[blocks objectAtIndex:j] componentsSeparatedByString:@","]
                                                                forKeys:[blockDict valueForKey:[blockKeys objectAtIndex:i]]]];
                }
            }
            [*dict setValue:temp forKey:[blockKeys objectAtIndex:i]];
        }
    }*/
}

#pragma mark - Networking

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection is successful.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    //NSLog(@"Socket did connect");
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection fails.
 * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
    NSLog(@"Socket did not connect: %@", error);
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    //NSLog(@"Socket did send data with tag: %li", tag);
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"Socket did not send data with tag: %li\n due to error: %@", tag, error);
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Socket did receive data:\n%@", response);
    dispatch_async(self.responseQueue, ^{
        [self parse:response];
    });
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"Socket did close with error: %@", error);
}

@end
