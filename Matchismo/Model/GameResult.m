//
//  GameResult.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/11/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "GameResult.h"

@interface GameResult ()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@property (readwrite, nonatomic) NSString *gameType;
@end

@implementation GameResult

#define ALL_RESULTS_KEY @"AllResults"
#define START_KEY @"StartDate"
#define END_KEY @"EndData"
#define SCORE_KEY @"Score"
#define GAME_TYPE_KEY @"GameType"
#define PLAYING_CARD_GAME_TYPE @"Card"
#define SET_CARD_GAME_TYPE @"Set"
#define PLAYING_CARD_GAME 1
#define SET_CARD_GAME 2

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

- (id)initWithGameType:(int)gameType
{
    self = [super init];
    if (self) {
        if (gameType == PLAYING_CARD_GAME) {
            _gameType = PLAYING_CARD_GAME_TYPE;
        } else if (gameType == SET_CARD_GAME) {
            _gameType = SET_CARD_GAME_TYPE;
        }
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (int)numberForGameType:(NSString *)gameType
{
    if ([gameType isEqualToString:SET_CARD_GAME_TYPE]) {
        return SET_CARD_GAME;
    } else if ([gameType isEqualToString:PLAYING_CARD_GAME_TYPE]) {
        return PLAYING_CARD_GAME;
    } else {
        return PLAYING_CARD_GAME;
    }
}

- (id)initFromPropertyList:(id)propertyList
{
    self = [self initWithGameType:[self numberForGameType:propertyList[GAME_TYPE_KEY]]];
    if (self) {
        if ([propertyList isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDictionary = (NSDictionary *)propertyList;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            if (!_start || !_end) {
                self = nil;
            }
        }
    }
    return self;
}

+ (NSArray *)allGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    for (id propertyList in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        GameResult *gameResult = [[GameResult alloc] initFromPropertyList:propertyList];
        [allGameResults addObject:gameResult];
    }
    return allGameResults;
}

- (void)synchronize
{
    NSMutableDictionary *allGameResults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!allGameResults) {
        allGameResults = [[NSMutableDictionary alloc] init];
    }
    allGameResults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:allGameResults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score), GAME_TYPE_KEY : self.gameType};
}

+ (void)resetUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
}

- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult
{
    if (self.score > otherResult.score) {
        return NSOrderedAscending;
    } else if (self.score < otherResult.score) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult
{
    return [otherResult.end compare:self.end];
}

- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult
{
    if (self.duration > otherResult.duration) {
        return NSOrderedDescending;
    } else if (self.duration < otherResult.duration) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareGameTypeToGameResult:(GameResult *)otherResult
{
    if ([self.gameType isEqualToString:otherResult.gameType]) {
        return NSOrderedSame;
    } else {
        return NSOrderedAscending;
    }
}

@end
