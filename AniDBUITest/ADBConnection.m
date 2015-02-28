//
//  ADBConnection.m
//  ADBPrototype
//
//  Created by Martin Fellner on 08.12.14.
//  Copyright (c) 2014 Pipelynx. All rights reserved.
//

#import "ADBConnection.h"
#import "MWLogging.h"
#import "NSData+zlib.h"

#define HOST @"api.anidb.net"
#define PORT 9000

#define ANIME_FIELDS @[@"id", @"dateFlags", @"yearRange", @"type", @"relatedAnimeIDList", @"relatedAnimeTypeList", @"categoryNameList", @"categoryWeightList", @"romajiName", @"kanjiName", @"englishName", @"otherNameList", @"shortNameList", @"synonymList", @"retired", @"retired", @"numberOfEpisodes", @"highestEpisodeNumber", @"numberOfSpecialEpisodes", @"airDate", @"endDate", @"url", @"imageName", @"categoryIDList", @"rating", @"ratingCount", @"tempRating", @"tempRatingCount", @"reviewRating", @"reviewCount", @"awardList", @"restrict18", @"animePlanetID", @"annID", @"allcinemaID", @"animeNfoID", @"unused", @"unused", @"unused", @"recordUpdated", @"characterIDList", @"creatorIDList", @"mainCreatorIDList", @"mainCreatorNameList", @"unused", @"unused", @"unused", @"unused", @"numberOfSpecials", @"numberOfCredits", @"numberOfOthers", @"numberOfTrailers", @"numberOfParodies", @"unused", @"unused", @"unused"]
#define RANDOM_ANIME_FIELDS @[@"id", @"numberOfEpisode", @"highestEpisodeNumber", @"numberOfSpecialEpisodes", @"rating", @"ratingCount", @"tempRating", @"tempRatingCount", @"reviewRating", @"reviewCount", @"yearRange", @"type", @"romajiName", @"kanjiName", @"englishName", @"otherNameList", @"shortNameList", @"synonymList", @"categoryNameList", @"airDate", @"endDate", @"dateFlags", @"restrict18", @"imageName"]
#define ANIME_KOMMA_KEYS @[@"categoryIDList", @"categoryNameList", @"categoryWeightList", @"characterIDList", @"creatorIDList", @"mainCreatorIDList", @"mainCreatorNameList"]
#define ANIME_APOSTROPHE_KEYS @[@"relatedAnimeIDList", @"relatedAnimeTypeList", @"otherNameList", @"shortNameList", @"synonymList"]

#define CHARACTER_FIELDS @[@"id", @"kanjiName", @"romajiName", @"imageName", @"animeBlocks", @"episodeList", @"recordUpdated", @"type", @"gender"]
#define CHARACTER_BLOCK_KEYS @{@"animeBlocks": @[@"animeID", @"appearanceType", @"creatorID", @"isMainSeiyuu"]}

#define CREATOR_FIELDS @[@"id", @"kanjiName", @"romajiName", @"type", @"imageName", @"urlEnglish", @"urlJapanese", @"wikiEnglish", @"wikiJapanese", @"recordUpdated"]

#define EPISODE_FIELDS @[@"id", @"animeID", @"length", @"rating", @"ratingCount", @"episodeNumber", @"englishName", @"romajiName", @"kanjiName", @"airDate", @"type"]

#define FILE_FIELDS @[@"id", @"animeID", @"episodeID", @"groupID", @"mylistID", @"otherEpisodeList", @"deprecated", @"state", @"size", @"ed2k", @"md5", @"sha1", @"crc32", @"unused", @"videoColourDepth", @"reserved", @"quality", @"source", @"audioCodecList", @"audioBitrateList", @"videoCodec", @"videoBitrate", @"videoResolution", @"fileExtension", @"dubLanguage", @"subLanguage", @"length", @"fileDescription", @"airDate", @"unused", @"unused", @"aniDBFilename", @"mylistState", @"mylistFilestate", @"mylistViewed", @"mylistViewDate", @"mylistStorage", @"mylistSource", @"mylistOther", @"unused", @"numberOfEpisodes", @"highestEpisodeNumber", @"yearRange", @"type", @"relatedAnimeIDList", @"relatedAnimeTypeList", @"categoryNameList", @"reserved", @"romajiName", @"kanjiName", @"englishName", @"otherNameList", @"shortNameList", @"synonymList", @"retired", @"retired", @"episodeNumber", @"episodeEnglishName", @"episodeRomajiName", @"episodeKanjiName", @"episodeRating", @"episodeRatingCount", @"unused", @"unused", @"groupName", @"groupShortName", @"unused", @"unused", @"unused", @"unused", @"unused", @"recordUpdated"]
#define FILE_KOMMA_KEYS @[@"categoryNameList"]
#define FILE_APOSTROPHE_KEYS @[@"audioCodecList", @"audioBitrateList", @"relatedAnimeIDList", @"relatedAnimeTypeList", @"dubLanguage", @"subLanguage"]

#define GROUP_FIELDS @[@"id", @"rating", @"ratingCount", @"animeCount", @"fileCount", @"name", @"shortName", @"ircChannel", @"ircServer", @"url", @"imageName", @"founded", @"disbanded", @"dateflags", @"lastRelease", @"lastActivity", @"relations"]
#define GROUP_BLOCK_KEYS @{@"relations": @[@"groupID", @"type"]}

#define GROUPSTATUS_FIELDS @[@"name", @"completionState", @"lastEpisodeNumber", @"rating", @"ratingCount", @"episodeRange"]

#define MYLIST_FIELDS @[@"id", @"fileID", @"episodeID", @"animeID", @"groupID", @"date", @"state", @"viewDate", @"storage", @"source", @"other", @"filestate"]

@interface ADBConnection ()

@property (strong, nonatomic) dispatch_queue_t requestQueue;
@property (strong, nonatomic) dispatch_queue_t responseQueue;
@property (strong, nonatomic) GCDAsyncUdpSocket *socket;
@property (strong, nonatomic) NSHashTable *delegates;

@property (strong, nonatomic) NSTimer *keepAliveTimer;

@property (strong, nonatomic) NSString *s;
@property (strong, nonatomic) NSString *imageServer;
@property (nonatomic) BOOL triedLogin;

@property (nonatomic) BOOL sendSync;
@property (strong, nonatomic) NSDictionary *syncReturn;

@end

static int versionDefault = 3;
static NSString *clientDefault = @"nijikon";
static int clientVersionDefault = 2;
static bool natDefault = YES;
static bool compressionDefault = YES;
static NSString *encodingDefault = @"UTF8";
static int mtuDefault = 1400;
static bool imageServerDefault = YES;

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
        _sendSync = NO;
        _syncReturn = nil;
        _sendDelay = 4.0f;
        
        NSError *error = nil;
        if (![self.socket connectToHost:HOST onPort:PORT error:&error])
            MWLogError(@"Error trying to connect: %@", error);
        error = nil;
        if (![self.socket beginReceiving:&error])
            MWLogError(@"Error trying to begin receiving: %@", error);
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

- (BOOL)hasSession {
    BOOL loggedIn = !([self.s isEqualToString:@""]);
    return loggedIn;
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    if (!self.triedLogin)
        [self sendRequest:[ADBRequest requestAuthWithUsername:username password:password version:versionDefault client:clientDefault clientVersion:clientVersionDefault NAT:natDefault compression:compressionDefault encoding:encodingDefault MTU:mtuDefault andImageServer:imageServerDefault]];
}

- (NSDictionary *)synchronousLoginWithUsername:(NSString *)username andPassword:(NSString *)password {
    if (!self.triedLogin)
        return [self sendRequest:[ADBRequest requestAuthWithUsername:username password:password version:versionDefault client:clientDefault clientVersion:clientVersionDefault NAT:natDefault compression:compressionDefault encoding:encodingDefault MTU:mtuDefault andImageServer:imageServerDefault] synchronouslyWithTimeout:0];
    return nil;
}

- (BOOL)waitForLogin {
    while (self.triedLogin)
        usleep(1000);
    return self.hasSession;
}

- (void)logout {
    [self sendRequest:[ADBRequest requestLogout]];
}

- (NSDictionary *)synchronousLogout {
    return [self sendRequest:[ADBRequest requestLogout] synchronouslyWithTimeout:0];
}

#pragma mark - Keep alive

- (void)startKeepAliveWithInterval:(NSTimeInterval)interval {
    [self stopKeepAlive];
    self.keepAliveTimer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(keepAliveWithTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.keepAliveTimer forMode:NSRunLoopCommonModes];
}

- (void)stopKeepAlive {
    if (self.keepAliveTimer)
        [self.keepAliveTimer invalidate];
    self.keepAliveTimer = nil;
}

- (void)keepAliveWithTimer:(NSTimer *)timer {
    [self keepAlive];
}

- (void)keepAlive {
    [self sendRequest:[ADBRequest requestRandomAnimeWithType:3]];
}

- (BOOL)isKeepingAlive {
    return (self.keepAliveTimer == nil)?NO:YES;
}

#pragma mark - Sending

- (BOOL)sendRequest:(NSString *)request {
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
                return NO;
            toSend = [request stringByAppendingString:self.s];
        }
    
    dispatch_async(self.requestQueue, ^{
        MWLogInfo(@"Sending:\n%@", toSend);
        if ([lastRequest isEqualToString:toSend]) {
            MWLogWarning(@"Trying to send same request again, dropped");
        }
        else {
            lastRequest = toSend;
            [self.socket sendData:[toSend dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1.0 tag:0];
            usleep(1000000 * self.sendDelay);
        }
    });
    return YES;
}

- (NSDictionary *)sendRequest:(NSString *)request synchronouslyWithTimeout:(NSTimeInterval)timeout {
    if (timeout == 0) {
        timeout = 86400;
    }
    _sendSync = YES;
    if (![self sendRequest:request])
        return nil;
    for (int i = 0; i < (timeout * 1000); i++)
        if (self.syncReturn == nil)
            usleep(1000);
        else
            break;
    NSDictionary *temp = self.syncReturn;
    self.syncReturn = nil;
    _sendSync = NO;
    return temp;
}

#pragma mark - Parsing

- (void)parse:(NSString *)response {
    if (_sendSync)
        [self setSyncReturn:[self parseResponse:response]];
    else
        [self callDelegatesWithDictionary:[self parseResponse:response]];
}

- (void)callDelegatesWithDictionary:(NSDictionary *)responseDictionary {
    for (id<ADBConnectionDelegate> delegate in [self.delegates copy]) {
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
        case ADBResponseCodeLoginAcceptedNewVersion: //AUTH
            [temp setValue:@"1" forKey:@"newVersion"];
        case ADBResponseCodeLoginAccepted: //AUTH
            [temp setValue:[firstLine objectAtIndex:1] forKey:@"sessionKey"];
            [temp setValue:[firstLine objectAtIndex:2] forKey:@"ownIP"];
            [temp setValue:[lines objectAtIndex:1] forKey:@"imageServer"];
            self.s = temp[@"sessionKey"];
            self.imageServer = temp[@"imageServer"];
            break;
            
        case ADBResponseCodeLoginFailed: //AUTH
            MWLogDebug(@"Login failed");
            break;
            
        case ADBResponseCodeClientVersionOutdated: //AUTH
            MWLogDebug(@"Client version outdated");
            break;
            
        case ADBResponseCodeClientBanned: //AUTH
            MWLogDebug(@"Client version banned");
            break;
            
        case ADBResponseCodeIllegalInputOrAccessDenied: //AUTH
            MWLogError(@"Illegal Input or Access Denied: %@", temp[@"request"]);
            @throw [NSException exceptionWithName:@"Illegal Input or Access Denied" reason:@"The request sent to aniDB was malformed or accessed data that is off-limits to the authenticated user." userInfo:temp];
            break;
            
        case ADBResponseCodeAniDBOutOfService: //AUTH
            MWLogNotice(@"AniDB out of service, try again later");
            break;
            
        case ADBResponseCodeLoggedOut: //LOGOUT
            self.s = @"";
            MWLogDebug(@"Logged out");
            break;
            
        case ADBResponseCodeNotLoggedIn:
            MWLogDebug(@"Not logged in");
            break;
            
        case ADBResponseCodeLoginFirst:
            self.s = @"";
            MWLogDebug(@"Login first");
            break;
            
        case ADBResponseCodeAnime:
            if (temp[@"tag"]) {
                [[NSScanner scannerWithString:temp[@"tag"]] scanHexLongLong:&mask];
                [temp addEntriesFromDictionary:[self parseAnime:[lines objectAtIndex:1] forMask:mask]];
            }
            else
                [temp addEntriesFromDictionary:[self parseRandomAnime:[lines objectAtIndex:1]]];
            break;
            
        case ADBResponseCodeNoSuchAnime:
            MWLogDebug(@"No such anime");
            break;
            
        case ADBResponseCodeCharacter:
            [temp addEntriesFromDictionary:[self parseCharacter:[lines objectAtIndex:1]]];
            break;
            
        case ADBResponseCodeNoSuchCharacter:
            MWLogDebug(@"No such character");
            break;
            
        case ADBResponseCodeCreator:
            [temp addEntriesFromDictionary:[self parseCreator:[lines objectAtIndex:1]]];
            break;
            
        case ADBResponseCodeNoSuchCreator:
            MWLogDebug(@"No such creator");
            break;
            
        case ADBResponseCodeEpisode:
            [temp addEntriesFromDictionary:[self parseEpisode:[lines objectAtIndex:1]]];
            break;
            
        case ADBResponseCodeNoSuchEpisode:
            MWLogDebug(@"No such episode");
            break;
            
        case ADBResponseCodeFile:
            [[NSScanner scannerWithString:[[temp[@"tag"] componentsSeparatedByString:@":"] objectAtIndex:0]] scanHexLongLong:&mask];
            [[NSScanner scannerWithString:[[temp[@"tag"] componentsSeparatedByString:@":"] objectAtIndex:1]] scanHexLongLong:&animeMask];
            [temp addEntriesFromDictionary:[self parseFile:[lines objectAtIndex:1] forFileMask:mask andAnimeMask:animeMask]];
            break;
            
        case ADBResponseCodeMultipleFilesFound:
            [temp setValue:[[lines objectAtIndex:1] componentsSeparatedByString:@"|"] forKey:@"fileIDs"];
            break;
            
        case ADBResponseCodeNoSuchFile:
            MWLogDebug(@"No such file");
            break;
            
        case ADBResponseCodeGroup:
            [temp addEntriesFromDictionary:[self parseGroup:[lines objectAtIndex:1]]];
            break;
            
        case ADBResponseCodeNoSuchGroup:
            MWLogDebug(@"No such group");
            break;
            
        case ADBResponseCodeGroupStatus:
            [temp setValue:[self parseGroupStatus:lines] forKey:@"groups"];
            break;
            
        case ADBResponseCodeNoSuchGroupsFound:
            MWLogDebug(@"No such groups found");
            break;
            
        case ADBResponseCodeBanned:
            MWLogError(@"Banned by aniDB");
            @throw [NSException exceptionWithName:@"Banned" reason:@"Banned by aniDB" userInfo:temp];
            break;
            
        case ADBResponseCodePong:
            if ([[temp[@"request"] extractRequestAttribute:@"nat"] integerValue] > 0)
                [temp setValue:lines[1] forKey:@"port"];
            break;
            
        case ADBResponseCodeUptime:
            [temp setValue:lines[1] forKey:@"uptime"];
            break;
            
        case ADBResponseCodeUser: //USER
            [temp setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:[lines[1] componentsSeparatedByString:@"|"] forKeys:@[@"id", @"username"]]];
            break;
            
        case ADBResponseCodeNoSuchUser: //USER, SENDMSG
            MWLogDebug(@"No such user");
            break;
            
        case ADBResponseCodeSendMessageSuccessful: //SENDMSG
            MWLogDebug(@"Send message successful");
            break;
            
        default:
            MWLogWarning(@"No response case applied:\n%@", response);
            break;
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

- (NSDictionary *)parseRandomAnime:(NSString *)valueString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *values = [valueString componentsSeparatedByString:@"|"];
    [dict setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:values forKeys:RANDOM_ANIME_FIELDS]];
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

#pragma mark - Networking

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection is successful.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    //MWLogInfo(@"Socket did connect");
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
    MWLogError(@"Socket did not connect: %@", error);
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    //MWLogInfo(@"Socket did send data with tag: %li", tag);
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    MWLogWarning(@"Socket did not send data with tag: %li\n due to error: %@", tag, error);
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    unsigned char buffer[2];
    [data getBytes:buffer length:2];
    if (buffer[0] == '\0' && buffer[1] == '\0') {
        NSError *error = nil;
        data = [[data subdataWithRange:NSMakeRange(2, data.length - 2)] bbs_dataByInflatingWithError:&error];
        if (error)
            MWLogError(@"%@", error);
    }
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    MWLogInfo(@"Socket did receive data:\n%@", response);
    dispatch_async(self.responseQueue, ^{
        [self parse:response];
    });
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    MWLogInfo(@"Socket did close with error: %@", error);
}

@end
