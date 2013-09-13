//
//  GameResult.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/11/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults;
- (id)initWithGameType:(int)gameType;
- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult;
- (NSComparisonResult)compareGameTypeToGameResult:(GameResult *)otherResult;
+ (void)resetUserDefaults;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (readonly, nonatomic, strong) NSString *gameType;
@property (nonatomic) int score;

@end
