//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/1/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameResult.h"
#import "Deck.h"
#import "Card.h"
#import "CardMatchingGame.h"

#define PLAYING_CARD_GAME 1.0
#define SET_CARD_GAME 2.0
#define TWO_CARD_MODE 0.0
#define THREE_CARD_MODE 1.0
#define GAME_SECTION 0.0
#define MATCHED_CARDS_SECTION 1.0

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (strong, nonatomic) NSMutableArray *matchedCards;
@property (nonatomic) NSInteger numberOfSections;

- (NSString *)matchingInformation;

// Methods that needs to be implemented by inherited classes
- (int)gameType;
- (int)gameMode;
- (Deck *)createDeck;
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card withAnimation:(BOOL)animated;
- (NSAttributedString *)historyInformation;
@property (nonatomic) NSUInteger startingCardCount;
@property (nonatomic) BOOL gameStarted;

@end