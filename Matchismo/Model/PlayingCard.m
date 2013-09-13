//
//  PlayingCard.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/2/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♠",@"♣",@"♥",@"♦"];
    return validSuits;
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 2;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    } else if (otherCards.count == 2) {
        PlayingCard *firstCard = [otherCards objectAtIndex:0];
        PlayingCard *secondCard = [otherCards objectAtIndex:1];
        if ([firstCard.suit isEqualToString:secondCard.suit]) {
            score = 1;
        } else if ([firstCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if ([secondCard.suit isEqualToString:self.suit]) {
            score = 1;
        }
        
        if (firstCard.rank == secondCard.rank) {
            score = 3;
        } else if (firstCard.rank == self.rank) {
            score = 3;
        } else if (secondCard.rank == self.rank) {
            score = 3;
        }
        
        if ([firstCard.suit isEqualToString:secondCard.suit] && [firstCard.suit isEqualToString:self.suit]) {
            score = 3;
        } else if (firstCard.rank == secondCard.rank && firstCard.rank == self.rank) {
            score = 8;
        }
    }
    
    return score;
}

@end
