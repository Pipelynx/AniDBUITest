//
//  DataClasses.h
//  AniDBCoreData
//
//  Created by Martin Fellner on 14.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "ADBRequest.h"
#import "AnimeCategory.h"
#import "Anime.h"
#import "File.h"
#import "Group.h"
#import "Mylist.h"
#import "Creator.h"
#import "Episode.h"
#import "Character.h"

#define AnimeCategoryEntityIdentifier @"AnimeCategory"
#define CategoryInfoEntityIdentifier @"CategoryInfo"
#define AnimeEntityIdentifier @"Anime"
#define CharacterEntityIdentifier @"Character"
#define CharacterInfoEntityIdentifier @"CharacterInfo"
#define CreatorEntityIdentifier @"Creator"
#define CreatorInfoEntityIdentifier @"CreatorInfo"
#define EpisodeEntityIdentifier @"Episode"
#define FileEntityIdentifier @"File"
#define VideoEntityIdentifier @"Video"
#define AudioEntityIdentifier @"Audio"
#define StreamEntityIdentifier @"Stream"
#define OtherEpisodeEntityIdentifier @"OtherEpisode"
#define GroupEntityIdentifier @"Group"
#define GroupRelationEntityIdentifier @"GroupRelation"
#define GroupStatusEntityIdentifier @"GroupStatus"
#define MylistEntityIdentifier @"Mylist"

typedef enum {
    ADBFileStateCRCOK =         0b00000001,
    ADBFileStateCRCError =      0b00000010,
    ADBFileStateVersion2 =      0b00000100,
    ADBFileStateVersion3 =      0b00001000,
    ADBFileStateVersion4 =      0b00010000,
    ADBFileStateVersion5 =      0b00100000,
    ADBFileStateUncensored =    0b01000000,
    ADBFileStateCensored =      0b10000000
} ADBFileState;