//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/1/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) NSInteger flippedCard;
@property (nonatomic) NSInteger previousFlippedCard;
@property (nonatomic) int flipCount;
@end

@implementation CardGameViewController

- (NSMutableArray *)matchedCards
{
    if (!_matchedCards) {
        _matchedCards = [[NSMutableArray alloc] init];
    }
    return _matchedCards;
}

- (NSInteger)numberOfSections
{
    if (!_numberOfSections) {
        _numberOfSections = 1;
    }
    return _numberOfSections;
}

- (NSString *)matchingInformation
{
    return self.game.matchingInformation;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == GAME_SECTION) {
        if ([self.game numberOfCardsInPlay] > 0) {
            return [self.game numberOfCardsInPlay];
        } else {
            return self.startingCardCount;
        }
    } else if (section == MATCHED_CARDS_SECTION) {
        return self.matchedCards.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    if(indexPath.section == GAME_SECTION) {
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card withAnimation:NO];
        
    } else if(indexPath.section == MATCHED_CARDS_SECTION) {
        [self updateCell:cell usingCard:[self.matchedCards objectAtIndex:indexPath.item] withAnimation:NO];
    }
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card withAnimation:(BOOL)animated; {}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
        self.previousFlippedCard = -1;
        _game.gameMode = [self gameMode];
    }
    return _game;
}

- (GameResult *)gameResult
{
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] initWithGameType:[self gameType]];
    }
    return _gameResult;
}

- (NSAttributedString *)historyInformation
{
    return nil;
}

- (int)gameType
{
    return PLAYING_CARD_GAME;
}

- (int)gameMode
{
    return TWO_CARD_MODE;
}

- (Deck *)createDeck
{
    return nil;
}

- (void)updateLabels
{
    self.historyLabel.attributedText = [self historyInformation];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        if (indexPath.section == GAME_SECTION) {
            Card *card = [self.game cardAtIndex:indexPath.item];
            if (card.isUnplayable) {
                if (self.numberOfSections == 1) {
                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:MATCHED_CARDS_SECTION];
                    self.numberOfSections = 2;
                    [self.cardCollectionView insertSections:indexSet];
                }
                [self.game deleteCardAtIndex:indexPath.item];
                [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
                NSIndexPath *indexPathToInsert = [NSIndexPath indexPathForItem:[self.cardCollectionView numberOfItemsInSection:MATCHED_CARDS_SECTION] inSection:MATCHED_CARDS_SECTION];
                NSLog(@"Card added");
                [self.matchedCards addObject:card];
                [self.cardCollectionView insertItemsAtIndexPaths:@[indexPathToInsert]];
                self.previousFlippedCard = -1;
                self.flippedCard = -1;
            } else {
                if ((self.flippedCard == indexPath.item || card.isFaceUp) && self.flippedCard != -1) {
                    [self updateCell:cell usingCard:card withAnimation:YES];
                } else if (self.previousFlippedCard != -1 && self.previousFlippedCard == indexPath.item) {
                    [self updateCell:cell usingCard:card withAnimation:YES];
                } else {
                    [self updateCell:cell usingCard:card withAnimation:NO];
                }
            }
        }
    }
    [self updateLabels];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath.section == GAME_SECTION && indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        self.flippedCard = indexPath.item;
        [self updateUI];
        if (self.previousFlippedCard != self.flippedCard) {
            self.previousFlippedCard = self.flippedCard;
        } else {
            self.previousFlippedCard = -1;
        }
        self.gameResult.score = self.game.score;
        self.flipCount++;
    }
}

- (IBAction)dealPressed
{
    if (self.numberOfSections == 2) {
        [self.cardCollectionView performBatchUpdates:^{
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:MATCHED_CARDS_SECTION];
            [self.cardCollectionView deleteSections:indexSet];
            self.numberOfSections = 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:GAME_SECTION];
            [self.cardCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        } completion:nil];
    } else {
        NSUInteger howManyToRemove = [self.cardCollectionView numberOfItemsInSection:GAME_SECTION] - self.startingCardCount;
        NSMutableArray *arrayOfIndexes = [[NSMutableArray alloc] initWithCapacity:howManyToRemove];
        for (int i = 0; i < howManyToRemove; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.cardCollectionView numberOfItemsInSection:GAME_SECTION] - i - 1 inSection:GAME_SECTION];
            [arrayOfIndexes addObject:indexPath];
            [self.game deleteCardAtIndex:indexPath.item];
            
        }
        [self.cardCollectionView deleteItemsAtIndexPaths:[arrayOfIndexes copy]];
    }
    self.matchedCards = nil;
    self.game = nil;
    self.gameResult = nil;
    self.previousFlippedCard = -1;
    self.flippedCard = -1;    
    self.flipCount = 0;
    self.scoreLabel.text = @"Score: 0";
    self.flipsLabel.text = @"Flips: 0";
    [self.cardCollectionView reloadData];
    [self updateUI];
}

@end
