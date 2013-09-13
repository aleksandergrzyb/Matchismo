//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/4/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (int)numberOfCardsInPlay;
- (void)deleteCardAtIndex:(NSUInteger)index;
- (BOOL)addNumberOfCards:(NSUInteger)numberOfCards;
- (NSArray *)getMatchedCards;

@property (nonatomic, readonly) int score;
@property (nonatomic) int gameMode; // 0 - 2 match mode game; 1 - 3 match mode game
@property (nonatomic, readonly) NSString* matchingInformation;
@property (nonatomic, readonly) int gainedPoints;

@end
