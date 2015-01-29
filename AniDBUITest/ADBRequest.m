//
//  ADBRequest.m
//  FirstTest
//
//  Created by Martin Fellner on 08.12.14.
//  Copyright (c) 2014 Pipelynx. All rights reserved.
//

#import "ADBRequest.h"
#import "NSString+Utilities.h"

@implementation ADBRequest

#pragma mark - Authentication

+ (NSString *)createAuthWithUsername:(NSString *)username
                           password:(NSString *)password
                            version:(int)apiVersion
                             client:(NSString *)clientName
                      clientVersion:(int)clientVersion
                                NAT:(BOOL)nat
                        compression:(BOOL)compression
                           encoding:(NSString *)encoding
                                MTU:(int)MTUValue
                     andImageServer:(BOOL)imageServer {
    return [NSString stringWithFormat:@"AUTH user=%@&pass=%@&protover=%i&client=%@&clientver=%i&nat=%i&comp=%i&enc=%@&mtu=%i&imgserver=%i",
            username, password, apiVersion, clientName, clientVersion, nat?1:0, compression?1:0, encoding, MTUValue, imageServer?1:0];
}

+ (NSString *)createLogout {
    return @"LOGOUT s=";
}

#pragma mark - Anime

+ (NSString *)createAnimeWithID:(NSNumber *)animeID andMask:(unsigned long long)animeMask {
    NSString *aMask = [[NSString stringWithFormat:@"%llx", animeMask] stringByPaddingLeftwithPattern:@"00000000000000"];
    return [NSString stringWithFormat:@"ANIME aid=%@&amask=%@&tag=%@&s=", animeID, aMask, aMask];
}

+ (NSString *)createAnimeWithID:(NSNumber *)animeID {
    return [self createAnimeWithID:animeID andMask:AM_DEFAULT];
}

+ (NSString *)createAnimeWithName:(NSString *)animeName andMask:(unsigned long long)animeMask {
    NSString *aMask = [[NSString stringWithFormat:@"%llx", animeMask] stringByPaddingLeftwithPattern:@"00000000000000"];
    return [NSString stringWithFormat:@"ANIME aname=%@&amask=%@&tag=%@&s=", animeName, aMask, aMask];
}

+ (NSString *)createAnimeWithName:(NSString *)animeName {
    return [self createAnimeWithName:animeName andMask:AM_DEFAULT];
}

#pragma mark - Character

+ (NSString *)createCharacterWithID:(NSNumber *)characterID {
    return [NSString stringWithFormat:@"CHARACTER charid=%@&s=", characterID];
}

#pragma mark - Creator

+ (NSString *)createCreatorWithID:(NSNumber *)creatorID {
    return [NSString stringWithFormat:@"CREATOR creatorid=%@&s=", creatorID];
}

#pragma mark - Episode

+ (NSString *)createEpisodeWithID:(NSNumber *)episodeID {
    return [NSString stringWithFormat:@"EPISODE eid=%@&s=", episodeID];
}

+ (NSString *)createEpisodeWithAnimeID:(NSNumber *)animeID andEpisodeNumber:(NSString *)episodeNumber {
    return [NSString stringWithFormat:@"EPISODE aid=%@&epno=%@&s=", animeID, episodeNumber];
}

+ (NSString *)createEpisodeWithAnimeName:(NSString *)animeName andEpisodeNumber:(NSString *)episodeNumber {
    return [NSString stringWithFormat:@"EPISODE aname=%@&epno=%@&s=", animeName, episodeNumber];
}

#pragma mark - File

+ (NSString *)createFileWithID:(NSNumber *)fileID fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask {
    NSString *fMask = [[NSString stringWithFormat:@"%llx", fileMask] stringByPaddingLeftwithPattern:@"0000000000"];
    NSString *aMask = [[NSString stringWithFormat:@"%llx", animeMask] stringByPaddingLeftwithPattern:@"00000000"];
    return [NSString stringWithFormat:@"FILE fid=%@&fmask=%@&amask=%@&tag=%@:%@&s=", fileID, fMask, aMask, fMask, aMask];
}

+ (NSString *)createFileWithID:(NSNumber *)fileID {
    return [self createFileWithID:fileID fileMask:FM_DEFAULT andAnimeMask:FM_ANIME_DEFAULT];
}

+ (NSString *)createFileWithSize:(unsigned long long)size ed2k:(NSString *)ed2k fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask {
    NSString *fMask = [[NSString stringWithFormat:@"%llx", fileMask] stringByPaddingLeftwithPattern:@"0000000000"];
    NSString *aMask = [[NSString stringWithFormat:@"%llx", animeMask] stringByPaddingLeftwithPattern:@"00000000"];
    return [NSString stringWithFormat:@"FILE size=%llu&ed2k=%@&fmask=%@&amask=%@&tag=%@:%@&s=", size, ed2k, fMask, aMask, fMask, aMask];
}

+ (NSString *)createFileWithSize:(unsigned long long)size andEd2k:(NSString *)ed2k {
    return [self createFileWithSize:size ed2k:ed2k fileMask:FM_DEFAULT andAnimeMask:FM_ANIME_DEFAULT];
}

+ (NSString *)createFileWithAnimeName:(NSString *)animeName groupName:(NSString *)groupName episodeNumber:(NSString *)episodeNumber fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask {
    NSString *fMask = [[NSString stringWithFormat:@"%llx", fileMask] stringByPaddingLeftwithPattern:@"0000000000"];
    NSString *aMask = [[NSString stringWithFormat:@"%llx", animeMask] stringByPaddingLeftwithPattern:@"00000000"];
    return [NSString stringWithFormat:@"FILE aname=%@&gname=%@&epno=%@&fmask=%@&amask=%@&tag=%@:%@&s=", animeName, groupName, episodeNumber, fMask, aMask, fMask, aMask];
}

+ (NSString *)createFileWithAnimeName:(NSString *)animeName groupName:(NSString *)groupName andEpisodeNumber:(NSString *)episodeNumber{
    return [self createFileWithAnimeName:animeName groupName:groupName episodeNumber:episodeNumber fileMask:FM_DEFAULT andAnimeMask:FM_ANIME_DEFAULT];
}

+ (NSString *)createFileWithAnimeName:(NSString *)animeName groupID:(NSNumber *)groupID episodeNumber:(NSString *)episodeNumber fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask {
    NSString *fMask = [[NSString stringWithFormat:@"%llx", fileMask] stringByPaddingLeftwithPattern:@"0000000000"];
    NSString *aMask = [[NSString stringWithFormat:@"%llx", animeMask] stringByPaddingLeftwithPattern:@"00000000"];
    return [NSString stringWithFormat:@"FILE aname=%@&gid=%@&epno=%@&fmask=%@&amask=%@&tag=%@:%@&s=", animeName, groupID, episodeNumber, fMask, aMask, fMask, aMask];
}

+ (NSString *)createFileWithAnimeName:(NSString *)animeName groupID:(NSNumber *)groupID andEpisodeNumber:(NSString *)episodeNumber {
    return [self createFileWithAnimeName:animeName groupID:groupID episodeNumber:episodeNumber fileMask:FM_DEFAULT andAnimeMask:FM_ANIME_DEFAULT];
}

+ (NSString *)createFileWithAnimeID:(NSNumber *)animeID groupName:(NSString *)groupName episodeNumber:(NSString *)episodeNumber fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask {
    NSString *fMask = [[NSString stringWithFormat:@"%llx", fileMask] stringByPaddingLeftwithPattern:@"0000000000"];
    NSString *aMask = [[NSString stringWithFormat:@"%llx", animeMask] stringByPaddingLeftwithPattern:@"00000000"];
    return [NSString stringWithFormat:@"FILE aid=%@&gname=%@&epno=%@&fmask=%@&amask=%@&tag=%@:%@&s=", animeID, groupName, episodeNumber, fMask, aMask, fMask, aMask];
}

+ (NSString *)createFileWithAnimeID:(NSNumber *)animeID groupName:(NSString *)groupName andEpisodeNumber:(NSString *)episodeNumber {
    return [self createFileWithAnimeID:animeID groupName:groupName episodeNumber:episodeNumber fileMask:FM_DEFAULT andAnimeMask:FM_ANIME_DEFAULT];
}

+ (NSString *)createFileWithAnimeID:(NSNumber *)animeID groupID:(NSNumber *)groupID episodeNumber:(NSString *)episodeNumber fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask {
    NSString *fMask = [[NSString stringWithFormat:@"%llx", fileMask] stringByPaddingLeftwithPattern:@"0000000000"];
    NSString *aMask = [[NSString stringWithFormat:@"%llx", animeMask] stringByPaddingLeftwithPattern:@"00000000"];
    return [NSString stringWithFormat:@"FILE aid=%@&gid=%@&epno=%@&fmask=%@&amask=%@&tag=%@:%@&s=", animeID, groupID, episodeNumber, fMask, aMask, fMask, aMask];
}

+ (NSString *)createFileWithAnimeID:(NSNumber *)animeID groupID:(NSNumber *)groupID andEpisodeNumber:(NSString *)episodeNumber {
    return [self createFileWithAnimeID:animeID groupID:groupID episodeNumber:episodeNumber fileMask:FM_DEFAULT andAnimeMask:FM_ANIME_DEFAULT];
}

+ (NSString *)createFileWithAnimeID:(NSNumber *)animeID andEpisodeNumber:(NSString *)episodeNumber {
    NSString *fMask = [[NSString stringWithFormat:@"%llx", FM_DEFAULT] stringByPaddingLeftwithPattern:@"0000000000"];
    NSString *aMask = [[NSString stringWithFormat:@"%llx", (unsigned long long)FM_ANIME_DEFAULT] stringByPaddingLeftwithPattern:@"00000000"];
    return [NSString stringWithFormat:@"FILE aid=%@&epno=%@&fmask=%@&amask=%@&tag=%@:%@&s=", animeID, episodeNumber, fMask, aMask, fMask, aMask];
}

#pragma mark - Group

+ (NSString *)createGroupWithID:(NSNumber *)groupID {
    return [NSString stringWithFormat:@"GROUP gid=%@&s=", groupID];
}

+ (NSString *)createGroupWithName:(NSString *)groupName {
    return [NSString stringWithFormat:@"GROUP gname=%@&s=", groupName];
}

#pragma mark - Group status

+ (NSString *)createGroupStatusWithAnimeID:(NSNumber *)animeID {
    return [NSString stringWithFormat:@"GROUPSTATUS aid=%@&tag=%@&s=", animeID, animeID];
}

+ (NSString *)createGroupStatusWithAnimeID:(NSNumber *)animeID andState:(int)state {
    return [NSString stringWithFormat:@"GROUPSTATUS aid=%@&state=%i&tag=%@&s=", animeID, state, animeID];
}

#pragma mark - Mylist

+ (NSString *)createMylistWithID:(NSNumber *)mylistID {
    return [NSString stringWithFormat:@"MYLIST lid=%@&s=", mylistID];
}

+ (NSString *)createMylistWithFileID:(NSNumber *)fileID {
    return [NSString stringWithFormat:@"MYLIST fid=%@&s=", fileID];
}

+ (NSString *)createMylistWithSize:(unsigned long long)size andEd2k:(NSString *)ed2k {
    return [NSString stringWithFormat:@"MYLIST size=%llu&ed2k=%@&s=", size, ed2k];
}

#pragma mark - Other

+ (NSString *)createRandomAnimeWithType:(int)type {
    return [NSString stringWithFormat:@"RANDOMANIME type=%i&s=", type];
}

+ (NSString *)createPingWithNAT:(BOOL)nat {
    return [NSString stringWithFormat:@"PING nat=%i", nat?1:0];
}

#pragma mark - Utilities

+ (NSString *)extractAttribute:(NSString *)attribute fromRequest:(NSString *)request {
    return [request extractRequestAttribute:attribute];
}

@end
