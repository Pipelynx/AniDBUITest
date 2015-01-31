//
//  ADBRequest.h
//  FirstTest
//
//  Created by Martin Fellner on 08.12.14.
//  Copyright (c) 2014 Pipelynx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNumber+Utilities.h"
#import "NSString+Utilities.h"

@interface ADBRequest : NSObject

#pragma mark - Authentication

+ (NSString *)requestAuthWithUsername:(NSString *)username
                           password:(NSString *)password
                            version:(int)apiVersion
                             client:(NSString *)clientName
                      clientVersion:(int)clientVersion
                                NAT:(BOOL)nat
                        compression:(BOOL)compression
                           encoding:(NSString *)encoding
                                MTU:(int)MTUValue
                     andImageServer:(BOOL)imageServer;

+ (NSString *)requestLogout;

#pragma mark - Anime

+ (NSString *)requestAnimeWithID:(NSNumber *)animeID andMask:(unsigned long long)animeMask;
+ (NSString *)requestAnimeWithID:(NSNumber *)animeID;
+ (NSString *)requestAnimeWithName:(NSString *)animeName andMask:(unsigned long long)animeMask;
+ (NSString *)requestAnimeWithName:(NSString *)animeName;

#pragma mark - Character

+ (NSString *)requestCharacterWithID:(NSNumber *)characterID;

#pragma mark - Creator

+ (NSString *)requestCreatorWithID:(NSNumber *)creatorID;

#pragma mark - Episode

+ (NSString *)requestEpisodeWithID:(NSNumber *)episodeID;
+ (NSString *)requestEpisodeWithAnimeID:(NSNumber *)animeID andEpisodeNumber:(NSString *)episodeNumber;
+ (NSString *)requestEpisodeWithAnimeName:(NSString *)animeName andEpisodeNumber:(NSString *)episodeNumber;

#pragma mark - File

+ (NSString *)requestFileWithID:(NSNumber *)fileID fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask;
+ (NSString *)requestFileWithID:(NSNumber *)fileID;
+ (NSString *)requestFileWithSize:(unsigned long long)size ed2k:(NSString *)ed2k fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask;
+ (NSString *)requestFileWithSize:(unsigned long long)size andEd2k:(NSString *)ed2k;
+ (NSString *)requestFileWithAnimeName:(NSString *)animeName groupName:(NSString *)groupName episodeNumber:(NSString *)episodeNumber fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask;
+ (NSString *)requestFileWithAnimeName:(NSString *)animeName groupName:(NSString *)groupName andEpisodeNumber:(NSString *)episodeNumber;
+ (NSString *)requestFileWithAnimeName:(NSString *)animeName groupID:(NSNumber *)groupID episodeNumber:(NSString *)episodeNumber fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask;
+ (NSString *)requestFileWithAnimeName:(NSString *)animeName groupID:(NSNumber *)groupID andEpisodeNumber:(NSString *)episodeNumber;
+ (NSString *)requestFileWithAnimeID:(NSNumber *)animeID groupName:(NSString *)groupName episodeNumber:(NSString *)episodeNumber fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask;
+ (NSString *)requestFileWithAnimeID:(NSNumber *)animeID groupName:(NSString *)groupName andEpisodeNumber:(NSString *)episodeNumber;
+ (NSString *)requestFileWithAnimeID:(NSNumber *)animeID groupID:(NSNumber *)groupID episodeNumber:(NSString *)episodeNumber fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask;
+ (NSString *)requestFileWithAnimeID:(NSNumber *)animeID groupID:(NSNumber *)groupID andEpisodeNumber:(NSString *)episodeNumber;
+ (NSString *)requestFileWithAnimeID:(NSNumber *)animeID andEpisodeNumber:(NSString *)episodeNumber;

#pragma mark - Group

+ (NSString *)requestGroupWithID:(NSNumber *)groupID;
+ (NSString *)requestGroupWithName:(NSString *)groupName;

#pragma mark - Group status

+ (NSString *)requestGroupStatusWithAnimeID:(NSNumber *)animeID;
+ (NSString *)requestGroupStatusWithAnimeID:(NSNumber *)animeID andState:(int)state;

#pragma mark - Mylist

+ (NSString *)requestMylistWithID:(NSNumber *)mylistID;
+ (NSString *)requestMylistWithFileID:(NSNumber *)fileID;
+ (NSString *)requestMylistWithSize:(unsigned long long)size andEd2k:(NSString *)ed2k;

#pragma mark - Other

+ (NSString *)requestRandomAnimeWithType:(int)type;

+ (NSString *)requestPingWithNAT:(BOOL)nat;

@end

#pragma mark - AniDB access masks

#define AM_DEFAULT                  0xFFE0FFFFF100F8
#define AM_ALL_NAMES                0x80FC0000000000
#define AM_CHARACTERS               0x80000000008000
#define AM_CREATORS                 0x80000000004000
#define AM_MAIN_CREATORS            0x80000000003000
#define AM_CHARACTERS_AND_CREATORS  0x8000000000F000

#define FM_DEFAULT                  0x7FFAFFF9FE
#define FM_ANIME_DEFAULT            0xFEE0FCC0
#define FM_ANIME_COMPLETE           0xFEFCFCC0

#pragma mark - Enums

typedef enum {
    ADBResponseCodeLoginAccepted = 200,
    ADBResponseCodeLoginAcceptedNewVersion = 201,
    ADBResponseCodeLoggedOut = 203,
    ADBResponseCodeResource = 205,
    ADBResponseCodeStats = 206,
    ADBResponseCodeTop = 207,
    ADBResponseCodeUptime = 208,
    ADBResponseCodeEncryption = 209,
    ADBResponseCodeMylistEntryAdded = 210,
    ADBResponseCodeMylistEntryDeleted = 211,
    ADBResponseCodeAddedFile = 214,
    ADBResponseCodeAddedStream = 215,
    ADBResponseCodeExportQueued = 217,
    ADBResponseCodeExportCancelled = 218,
    ADBResponseCodeEncodingChanged = 219,
    ADBResponseCodeFile = 220,
    ADBResponseCodeMylist = 221,
    ADBResponseCodeMylistStats = 222,
    ADBResponseCodeWishlist = 223,
    ADBResponseCodeNotification = 224,
    ADBResponseCodeGroupStatus = 225,
    ADBResponseCodeWishlistEntryAdded = 226,
    ADBResponseCodeWishlistEntryDeleted = 227,
    ADBResponseCodeWishlistEntryUpdated = 228,
    ADBResponseCodeMultipleWishlist = 229,
    ADBResponseCodeAnime = 230,
    ADBResponseCodeAnimeBestMatch = 231,
    ADBResponseCodeRandomAnime = 232,
    ADBResponseCodeAnimeDescription = 233,
    ADBResponseCodeReview = 234,
    ADBResponseCodeCharacter = 235,
    ADBResponseCodeSong = 236,
    ADBResponseCodeAnimetag = 237,
    ADBResponseCodeCharacterTag = 238,
    ADBResponseCodeEpisode = 240,
    ADBResponseCodeUpdated = 243,
    ADBResponseCodeTitle = 244,
    ADBResponseCodeCreator = 245,
    ADBResponseCodeNotificationEntryAdded = 246,
    ADBResponseCodeNotificationEntryDeleted = 247,
    ADBResponseCodeNotificationEntryUpdated = 248,
    ADBResponseCodeMultipleNotification = 249,
    ADBResponseCodeGroup = 250,
    ADBResponseCodeCategory = 251,
    ADBResponseCodeBuddyList = 253,
    ADBResponseCodeBuddyState = 254,
    ADBResponseCodeBuddyAdded = 255,
    ADBResponseCodeBuddyDeleted = 256,
    ADBResponseCodeBuddyAccepted = 257,
    ADBResponseCodeBuddyDenied = 258,
    ADBResponseCodeVoted = 260,
    ADBResponseCodeVoteFound = 261,
    ADBResponseCodeVoteUpdated = 262,
    ADBResponseCodeVoteRevoked = 263,
    ADBResponseCodeHotAnime = 265,
    ADBResponseCodeRandomRecommendation = 266,
    ADBResponseCodeRandomSimilar = 267,
    ADBResponseCodeNotificationEnabled = 270,
    ADBResponseCodeNotifyackSuccessfulMessage = 281,
    ADBResponseCodeNotifyackSuccessfulNotification = 282,
    ADBResponseCodeNotificationState = 290,
    ADBResponseCodeNotiylist = 291,
    ADBResponseCodeNotifyMessage = 292,
    ADBResponseCodeNotifygetNotify = 293,
    ADBResponseCodeSendmessageSuccessful = 294,
    ADBResponseCodeUserID = 295,
    ADBResponseCodeCalendar = 297,
    
    ADBResponseCodePong = 300,
    ADBResponseCodeAuthpong = 301,
    ADBResponseCodeNoSuchResource = 305,
    ADBResponseCodeAPIPasswordNotDefined = 309,
    ADBResponseCodeFileAlreadyInMylist = 310,
    ADBResponseCodeMylistEntryEdited = 311,
    ADBResponseCodeMultipleMylistEntries = 312,
    ADBResponseCodeWatched = 313,
    ADBResponseCodeSizeHashExists = 314,
    ADBResponseCodeInvalidData = 315,
    ADBResponseCodeStreamNoIDUsed = 316,
    ADBResponseCodeExportNoSuchTemplate = 317,
    ADBResponseCodeExportAlreadyInQueue = 318,
    ADBResponseCodeExportNoExportQueuedOrIsProcessing = 319,
    ADBResponseCodeNoSuchFile = 320,
    ADBResponseCodeNoSuchEntry = 321,
    ADBResponseCodeMultipleFilesFound = 322,
    ADBResponseCodeNoSuchWishlist = 323,
    ADBResponseCodeNoSuchNotification = 324,
    ADBResponseCodeNoSuchGroupsFound = 325,
    ADBResponseCodeNoSuchAnime = 330,
    ADBResponseCodeNoSuchDescription = 333,
    ADBResponseCodeNoSuchReview = 334,
    ADBResponseCodeNoSuchCharacter = 335,
    ADBResponseCodeNoSuchSong = 336,
    ADBResponseCodeNoSuchAnimetag = 337,
    ADBResponseCodeNoSuchCharactertag = 338,
    ADBResponseCodeNoSuchEpisode = 340,
    ADBResponseCodeNoSuchUpdates = 343,
    ADBResponseCodeNoSuchTitles = 344,
    ADBResponseCodeNoSuchCreator = 345,
    ADBResponseCodeNoSuchGroup = 350,
    ADBResponseCodeNoSuchCategory = 351,
    ADBResponseCodeBuddyAlreadyAdded = 355,
    ADBResponseCodeNoSuchBuddy = 356,
    ADBResponseCodeBuddyAlreadyAccepted = 357,
    ADBResponseCodeBuddyAlreadyDenied = 358,
    ADBResponseCodeNoSuchVote = 360,
    ADBResponseCodeInvalidVoteType = 361,
    ADBResponseCodeInvalidVoteValue = 362,
    ADBResponseCodePermvoteNotAllowed = 363,
    ADBResponseCodeAlreadyPermvoted = 364,
    ADBResponseCodeHotAnimeEmpty = 365,
    ADBResponseCodeRandomRecommendationEmpty = 366,
    ADBResponseCodeRandomSimilarEmpty = 367,
    ADBResponseCodeNotificationDisabled = 370,
    ADBResponseCodeNoSuchEntryMessage = 381,
    ADBResponseCodeNoSuchEntryNotfication = 382,
    ADBResponseCodeNoSuchMessage = 392,
    ADBResponseCodeNoSuchNotify = 393,
    ADBResponseCodeNoSuchUser = 394,
    ADBResponseCodeCalendarEmpty = 397,
    ADBResponseCodeNoChanges = 399,
    
    ADBResponseCodeNotLoggedIn = 403,
    ADBResponseCodeNoSuchMylistFile = 410,
    ADBResponseCodeNoSuchMylistEntry = 411,
    ADBResponseCodeMylistUnavailable = 412,
    
    ADBResponseCodeLoginFailed = 500,
    ADBResponseCodeLoginFirst = 501,
    ADBResponseCodeAccessDenied = 502,
    ADBResponseCodeClientVersionOutdated = 503,
    ADBResponseCodeClientBanned = 504,
    ADBResponseCodeIllegalInputOrAccessDenied = 505,
    ADBResponseCodeInvalidSession = 506,
    ADBResponseCodeNoSuchEncryptionType = 509,
    ADBResponseCodeEncodingNotSupported = 519,
    ADBResponseCodeBanned = 555,
    ADBResponseCodeUnknownCommand = 598,
    
    ADBResponseCodeInternalServerError = 600,
    ADBResponseCodeAniDBOutOfService = 601,
    ADBResponseCodeServerBusy = 602,
    ADBResponseCodeNoData= 603,
    ADBResponseCodeTimeout = 604,
    ADBResponseCodeAPIViolation = 666,
    
    ADBResponseCodePushackConfirmed = 701,
    ADBResponseCodeNoSuchPacketPending = 702,
} ADBResponseCode;

typedef enum {
    ADBGroupStatusOngoingCompleteOrFinished = 0,
    ADBGroupStatusOngoing = 1,
    ADBGroupStatusStalled = 2,
    ADBGroupStatusComplete = 3,
    ADBGroupStatusDropped = 4,
    ADBGroupStatusFinished = 5,
    ADBGroupStatusSpecialsOnly = 6
} ADBGroupStatusState;