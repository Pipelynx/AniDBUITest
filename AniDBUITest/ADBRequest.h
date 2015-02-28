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
#import "NSDictionary+Anidb.h"

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
    ADBResponseCodeSendMessageSuccessful = 294,
    ADBResponseCodeUser = 295,
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

typedef enum {
    ADBRandomAnimeTypeAniDB = 0,
    ADBRandomAnimeTypeWatched = 1,
    ADBRandomAnimeTypeUnwatched = 2,
    ADBRandomAnimeTypeMylist = 3
} ADBRandomAnimeType;

typedef enum {
    ADBMylistStateUnknown = 0,
    ADBMylistStateOnHDD = 1,
    ADBMylistStateOnCD = 2,
    ADBMylistStateDeleted = 3
} ADBMylistState;

typedef enum {
    ADBAnimeRelationTypeSequel = 1,
    ADBAnimeRelationTypePrequel = 2,
    ADBAnimeRelationTypeSameSetting = 11,
    ADBAnimeRelationTypeAlternativeSetting = 12,
    ADBAnimeRelationTypeAlternativeVersion = 32,
    ADBAnimeRelationTypeMusicVideo = 41,
    ADBAnimeRelationTypeCharacter = 42,
    ADBAnimeRelationTypeSideStory = 51,
    ADBAnimeRelationTypeParentStory = 52,
    ADBAnimeRelationTypeSummary = 61,
    ADBAnimeRelationTypeFullStory = 62,
    ADBAnimeRelationTypeOther = 100
} ADBAnimeRelationType;

@interface ADBRequest : NSObject

#pragma mark - Authentication

/*!Get a request for authenticating to aniDB.
 *
 * @param username The username of the user being authenticated
 * @param password The password of the user being authenticated
 * @param apiVersion The version of the UDP API used by the client
 * @param clientName The name of the client as registered in aniDB
 * @param clientVersion The version of the client as registered in aniDB
 * @param nat Whether or not aniDB should return IP and port information
 * @param compression Whether or not aniDB should compress responses that exceed the MTU
 * @param mtu A value between 400 and 1400 indicating the maximum length of returned UDP packets
 * @param imageServer Whether or not aniDB should return the base URL for the imageServer for the authenticating user
 *
 * @result The request to be sent in a UDP packet
 */
+ (NSString *)requestAuthWithUsername:(NSString *)username password:(NSString *)password version:(int)apiVersion client:(NSString *)clientName clientVersion:(int)clientVersion NAT:(BOOL)nat compression:(BOOL)compression encoding:(NSString *)encoding MTU:(int)mtu andImageServer:(BOOL)imageServer;

/*!Get a request for logging out of aniDB.
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestLogout;

#pragma mark - Anime

/*!Get a request to receive anime information.
 *
 * @param animeID The ID of the anime as stored in aniDB
 * @param animeMask A bitmask specifying which attributes should be returned
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestAnimeWithID:(NSNumber *)animeID andMask:(unsigned long long)animeMask;

/*!Get a request to receive anime information.
 *
 * @param animeID The ID of the anime as stored in aniDB
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestAnimeWithID:(NSNumber *)animeID;

/*!Get a request to receive anime information.
 *
 * @param animeName The name of the anime as stored in aniDB, this can be any name including synonyms and is case insensitive
 * @param animeMask A bitmask specifying which attributes should be returned
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestAnimeWithName:(NSString *)animeName andMask:(unsigned long long)animeMask;

/*!Get a request to receive anime information.
 *
 * @param animeName The name of the anime as stored in aniDB, this can be any name including synonyms and is case insensitive
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestAnimeWithName:(NSString *)animeName;

#pragma mark - Character

/*!Get a request to receive character information.
 *
 * @param characterID The ID of the character as stored in aniDB
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestCharacterWithID:(NSNumber *)characterID;

#pragma mark - Creator

/*!Get a request to receive creator information.
 *
 * @param creatorID The ID of the creator as stored in aniDB
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestCreatorWithID:(NSNumber *)creatorID;

#pragma mark - Episode

/*!Get a request to receive episode information.
 *
 * @param episodeID The ID of the episode as stored in aniDB
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestEpisodeWithID:(NSNumber *)episodeID;

/*!Get a request to receive episode information.
 *
 * @param animeID The ID of the anime that contains the episode, as stored in aniDB
 * @param episodeNumber The episode number of the episode with the anime, this can have a letter prefix for special episode, like "C01" for the first Credits episode
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestEpisodeWithAnimeID:(NSNumber *)animeID andEpisodeNumber:(NSString *)episodeNumber;

/*!Get a request to receive episode information.
 *
 * @param animeName The name of the anime that contains the episode, as stored in aniDB, this can be any name including synonyms and is case insensitive
 * @param episodeNumber The episode number of the episode with the anime, this can have a letter prefix for special episode, like "C01" for the first Credits episode
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestEpisodeWithAnimeName:(NSString *)animeName andEpisodeNumber:(NSString *)episodeNumber;

#pragma mark - File

/*!Get a request to receive file information.
 *
 * @param fileID The ID of the file as stored in aniDB
 * @param fileMask A bitmask specifying which file attributes should be returned
 * @param animeMask A bitmask specifying which attributes from the associated anime should be returned
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestFileWithID:(NSNumber *)fileID fileMask:(unsigned long long)fileMask andAnimeMask:(unsigned long long)animeMask;

/*!Get a request to receive file information.
 *
 * @param fileID The ID of the file as stored in aniDB
 *
 * @return The request to be sent in a UDP packet
 */
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
+ (NSString *)requestMylistAddWithFileID:(NSNumber *)fileID andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistAddWithSize:(unsigned long long)size ed2k:(NSString *)ed2k andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistAddWithAnimeID:(NSNumber *)animeID groupID:(NSNumber *)groupID episodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistAddWithAnimeID:(NSNumber *)animeID groupName:(NSString *)groupName episodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistAddWithAnimeID:(NSNumber *)animeID genericGroupEpisodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistAddWithAnimeName:(NSString *)animeName groupID:(NSNumber *)groupID episodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistAddWithAnimeName:(NSString *)animeName groupName:(NSString *)groupName episodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistAddWithAnimeName:(NSString *)animeName genericGroupEpisodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistAddWithParameters:(NSDictionary *)parameters;

+ (NSString *)requestMylistEditWithMylistID:(NSNumber *)mylistID andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistEditWithFileID:(NSNumber *)fileID andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistEditWithSize:(unsigned long long)size ed2k:(NSString *)ed2k andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistEditWithAnimeID:(NSNumber *)animeID groupID:(NSNumber *)groupID episodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistEditWithAnimeID:(NSNumber *)animeID groupName:(NSString *)groupName episodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistEditWithAnimeID:(NSNumber *)animeID genericGroupEpisodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistEditWithAnimeName:(NSString *)animeName groupID:(NSNumber *)groupID episodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistEditWithAnimeName:(NSString *)animeName groupName:(NSString *)groupName episodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistEditWithAnimeName:(NSString *)animeName genericGroupEpisodeRange:(NSString *)episodeRange andParameters:(NSDictionary *)parameters;
+ (NSString *)requestMylistEditWithParameters:(NSDictionary *)parameters;

/*!Get a parameter dictionary to pass with a requestMylist message, if any of the parameters are nil (or invalid), they will not be included in the dictionary.
 *
 * @param state The state of the file in the mylist. Valid values: 0 = Unknown, 1 = On a harddrive, 2 = On a disc, 3 = Deleted
 * @param viewed YES if the user has watched the file already, NO if not
 * @param viewDate The date when the file was watched.
 * @param source Where the file was acquired
 * @param storage Where the file is stored
 * @param other Miscellaneous information the user wants to add to the mylist entry
 *
 * @return The dictionary with the parameters set
 */
+ (NSDictionary *)parameterDictionaryWithState:(ADBMylistState)state viewed:(BOOL)viewed viewDate:(NSDate *)viewDate source:(NSString *)source storage:(NSString *)storage andOther:(NSString *)other;

#pragma mark - User

/*!Get a request to receive user information.
 *
 * @param userID The ID of the user as stored in aniDB
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestUserWithID:(NSNumber *)userID;

/*!Get a request to receive user information.
 *
 * @param username The name of the user as stored in aniDB
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestUserWithName:(NSString *)username;

/*!Get a request to send an aniDB message to another user.
 *
 * @param title The title of the message. AniDB enforces a limit of 50 characters, characters beyond that will be discarded.
 * @param body The body of the message. AniDB enforces a limit of 900 characters, characters beyond that will be discarded.
 * @param username The name of the recipient user as stored in aniDB
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestSendMessageWithTitle:(NSString *)title andBody:(NSString *)body toUser:(NSString *)username;

#pragma mark - Other
/*!Get a request to receive anime information for a random anime.
 *
 * @param type The scope from which the random anime should be taken. Valid values: 0 = from the entire aniDB, 1 = from all watched in the users mylist, 2 = from all unwatched in the users mylist, 3 = from the users mylist
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestRandomAnimeWithType:(ADBRandomAnimeType)type;

/*!Get a request to receive a pong response.
 *
 * @param nat Whether or not aniDB should return IP and port information
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestPingWithNAT:(BOOL)nat;

/*!Get a request to receive server uptime information.
 *
 * @return The request to be sent in a UDP packet
 */
+ (NSString *)requestUptime;

@end

#pragma mark - AniDB access masks

#define AM_FULL                     0xFFFCFFFFF1F0F8
#define AM_ALL_NAMES                0x80FC0000000000
#define AM_CHARACTERS               0x80000000008000
#define AM_CREATORS                 0x80000000004000
#define AM_MAIN_CREATORS            0x80000000003000
#define AM_CHARACTERS_AND_CREATORS  0x8000000000F000

#define FM_FULL                     0x7FFAFFF9FE
#define FM_ANIME_FULL               0xFEFCFCC0