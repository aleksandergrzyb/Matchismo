//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/4/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) Deck *usedDeck;
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString* matchingInformation;
@property (readwrite, nonatomic, strong) NSMutableArray* matchedCards;
@property (nonatomic, readwrite) int gainedPoints;
@end

@implementation CardMatchingGame

- (BOOL)addNumberOfCards:(NSUInteger)numberOfCards
{
    for (int i = 0; i < numberOfCards; i++) {
        Card *card = [self.usedDeck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)deleteCardAtIndex:(NSUInteger)index
{
    if (index < self.cards.count) {
        [self.cards removeObjectAtIndex:index];
    }
}

- (int)numberOfCardsInPlay
{
    return [self.cards count];
}

- (NSArray *)getMatchedCards
{
    return [self.matchedCards copy];
}

- (NSMutableArray *)matchedCards
{
    if (!_matchedCards) {
        _matchedCards = [[NSMutableArray alloc] init];
    }
    return _matchedCards;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    _usedDeck = deck;
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    BOOL actionTaken = NO;
    Card *card = [self cardAtIndex:index];
    if (self.gameMode == 0) {
        if (!card.isUnplayable) {
            if (!card.isFaceUp) {
                for (Card *otherCard in self.cards) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            otherCard.unplayable = YES;
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            self.matchingInformation = [NSString stringWithFormat:@"Matched %@ for %d points!", [@[card, otherCard] componentsJoinedByString:@" & "], matchScore * MATCH_BONUS];
                        } else {
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            self.matchingInformation = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", [@[card, otherCard] componentsJoinedByString:@" & "], MISMATCH_PENALTY];
                        }
                        actionTaken = YES;
                        break;
                    }
                }
                self.score -= FLIP_COST;
                if (!actionTaken) self.matchingInformation = [NSString stringWithFormat:@"Flipped %@!", card];
            }
            card.faceUp = !card.isFaceUp;
        }
    } else {
        actionTaken = NO;
        self.matchingInformation = @"NO";
        if (self.matchedCards.count == 3) {
            [self.matchedCards removeAllObjects];
        }
        if (!card.isUnplayable) {
            if (!card.isFaceUp) {
                Card *firstCard = nil;
                int numberOfSelectedCards = 0;
                for (Card *otherCard in self.cards) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        if (numberOfSelectedCards == 0) {
                            firstCard = otherCard;
                            numberOfSelectedCards++;
                        } else if (numberOfSelectedCards == 1) {
                            int matchScore = [card match:@[firstCard, otherCard]];
                            if (matchScore) {
                                firstCard.unplayable = YES;
                                otherCard.unplayable = YES;
                                card.unplayable = YES;
                                self.score += matchScore * MATCH_BONUS;
                                self.gainedPoints = matchScore * MATCH_BONUS;
                                if (![self.matchedCards containsObject:card]) {
                                    [self.matchedCards addObject:card];
                                }
                                if (![self.matchedCards containsObject:firstCard]) {
                                    [self.matchedCards addObject:firstCard];
                                }
                                if (![self.matchedCards containsObject:otherCard]) {
                                    [self.matchedCards addObject:otherCard];
                                }
                                self.matchingInformation = @"YES";
                            } else {
                                firstCard.faceUp = NO;
                                otherCard.faceUp = NO;
                                self.score -= MISMATCH_PENALTY;
                                self.gainedPoints = MISMATCH_PENALTY;
                                if (![self.matchedCards containsObject:card]) {
                                    [self.matchedCards addObject:card];
                                }
                                if (![self.matchedCards containsObject:firstCard]) {
                                    [self.matchedCards addObject:firstCard];
                                }
                                if (![self.matchedCards containsObject:otherCard]) {
                                    [self.matchedCards addObject:otherCard];
                                }
                                self.matchingInformation = @"NO";
                            }
                            actionTaken = YES;
                            break;
                        }
                    } else if (!otherCard.isFaceUp) {
                        if ([self.matchedCards containsObject:otherCard]) {
                            [self.matchedCards removeObject:otherCard];
                        }
                    }
                }
                self.score -= FLIP_COST;
                if (!actionTaken) {
                    if (!card.isFaceUp) {
                        [self.matchedCards addObject:card];
                    }
                    self.matchingInformation = @"NO";
                }
            }
            card.faceUp = !card.isFaceUp;
            if (!card.isFaceUp) {
                if ([self.matchedCards containsObject:card]) {
                    [self.matchedCards removeObject:card];
                }
            }
        }
    }
}


@end
