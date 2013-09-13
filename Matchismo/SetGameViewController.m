//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/10/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardCollectionViewCell.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet SetCardView *firstCard;
@property (weak, nonatomic) IBOutlet SetCardView *secondCard;
@property (weak, nonatomic) IBOutlet SetCardView *thirdCard;
@property (nonatomic) int flipCount;
@end

@implementation SetGameViewController

#define NUMBER_OF_CARDS 12.0
#define DEFAULT_FONT_SIZE 14.0
#define NUMBER_OF_CARDS_TO_ADD 3.0

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card withAnimation:(BOOL)animated;
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
            setCardView.faceUp = setCard.isFaceUp;
        }
    }
}
- (IBAction)moreCardsPressed
{
    BOOL thereIsMoreCards = [self.game addNumberOfCards:NUMBER_OF_CARDS_TO_ADD];
    if (thereIsMoreCards) {
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:[self.cardCollectionView numberOfItemsInSection:GAME_SECTION] inSection:GAME_SECTION];
        NSIndexPath *secondIndexPath = [NSIndexPath indexPathForRow:[self.cardCollectionView numberOfItemsInSection:GAME_SECTION] + 1 inSection:GAME_SECTION];
        NSIndexPath *thirdIndexPath = [NSIndexPath indexPathForRow:[self.cardCollectionView numberOfItemsInSection:GAME_SECTION] + 2 inSection:GAME_SECTION];
        [self.cardCollectionView insertItemsAtIndexPaths:@[firstIndexPath, secondIndexPath, thirdIndexPath]];
        [self.cardCollectionView scrollToItemAtIndexPath:thirdIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There is no more cards in the deck!" delegate:nil cancelButtonTitle:@"Ok :(" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (NSUInteger)startingCardCount
{
    return NUMBER_OF_CARDS;
}

- (int)gameMode
{
    return THREE_CARD_MODE;
}

- (int)gameType
{
    return SET_CARD_GAME;
}

- (NSAttributedString *)getStringForCard:(Card *)card
{
    SetCard *setCard = (SetCard *)card;
    NSMutableAttributedString *attributedStringOfCard = [[NSMutableAttributedString alloc] initWithString:setCard.contents];
    NSRange range = [[attributedStringOfCard string] rangeOfString:setCard.contents];
    [attributedStringOfCard addAttributes:@{NSForegroundColorAttributeName : [self colorOfCard:card]} range:range];
    return [attributedStringOfCard copy];
}

- (UIColor *)colorOfCard:(Card *)card
{
    SetCard *setCard = (SetCard *)card;
    UIColor *colorOfCard;
    if (setCard.color == GREEN_COLOR) {
        colorOfCard = [UIColor greenColor];
    } else if (setCard.color == RED_COLOR) {
        colorOfCard = [UIColor redColor];
    } else if (setCard.color == PURPLE_COLOR) {
        colorOfCard = [UIColor purpleColor];
    }
    return colorOfCard;
}

- (void)updateSelectedCardsViews
{
    self.firstCard.hidden = YES;
    self.secondCard.hidden = YES;
    self.thirdCard.hidden = YES;
    NSArray *arrayOfViews = @[self.firstCard, self.secondCard, self.thirdCard];
    for (int i = 0; i < [self.game getMatchedCards].count; i++) {
        SetCard *selectedCard = [self.game getMatchedCards][i];
        SetCardView *selectedView = ((SetCardView *)[arrayOfViews objectAtIndex:i]);
        selectedView.hidden = NO;
        selectedView.number = selectedCard.number;
        selectedView.symbol = selectedCard.symbol;
        selectedView.shading = selectedCard.shading;
        selectedView.color = selectedCard.color;
        selectedView.faceUp = NO;
    }
}

- (NSAttributedString *)historyInformation
{
    if (!self.game.matchingInformation) {
        self.firstCard.hidden = YES;
        self.secondCard.hidden = YES;
        self.thirdCard.hidden = YES;
        return [[[NSAttributedString alloc] initWithString:@""] copy];
    } else {
        if ([self.game getMatchedCards].count >= 1) {
            [self updateSelectedCardsViews];
        }
        NSMutableAttributedString *historyAttributedString;
        NSString *information;
        if ([self.game getMatchedCards].count == 1 || [self.game getMatchedCards].count == 2) {
            information = [NSString stringWithFormat:@"Flipped %@", [[self.game getMatchedCards] lastObject]];
            NSRange rangeOfCard = [information rangeOfString:[[[self.game getMatchedCards] lastObject] description]];
            historyAttributedString = [[NSMutableAttributedString alloc] initWithString:information];
            [historyAttributedString addAttributes:@{NSForegroundColorAttributeName : [self colorOfCard:[[self.game getMatchedCards] lastObject]]} range:rangeOfCard];
        } else if ([self.game getMatchedCards].count == 3) {
            if ([self.game.matchingInformation isEqualToString:@"YES"]) {
                information = [NSString stringWithFormat:@"matched for %d points! :)", self.game.gainedPoints];
                NSRange rangeOfWord = [information rangeOfString:@"matched"];
                historyAttributedString = [[NSMutableAttributedString alloc] initWithString:information];
                [historyAttributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor]} range:rangeOfWord];
            } else {
                information = [NSString stringWithFormat:@"don't match! %d point penalty! :(", self.game.gainedPoints];
                NSRange rangeOfWord = [information rangeOfString:@"don't match!"];
                historyAttributedString = [[NSMutableAttributedString alloc] initWithString:information];
                [historyAttributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:rangeOfWord];
            }
        } else {
            information = @"";
            self.firstCard.hidden = YES;
            self.secondCard.hidden = YES;
            self.thirdCard.hidden = YES;
            historyAttributedString = [[NSMutableAttributedString alloc] initWithString:information];
        }
        NSRange range = [information rangeOfString:information];
        UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:DEFAULT_FONT_SIZE];
        NSParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle];
        NSMutableParagraphStyle *mutableStyle = [style mutableCopy];
        mutableStyle.alignment = NSTextAlignmentLeft;
        [historyAttributedString addAttributes:@{NSFontAttributeName : font} range:range];
        [historyAttributedString addAttributes:@{NSParagraphStyleAttributeName : [mutableStyle copy]} range:range];
        CGFloat sizeOfFont = DEFAULT_FONT_SIZE;
        while ([historyAttributedString size].width > self.historyLabel.frame.size.width) {
            font = [UIFont fontWithName:@"Helvetica Neue" size:sizeOfFont];
            [historyAttributedString addAttributes:@{NSFontAttributeName : font} range:range];
            sizeOfFont -= 1;
        }
        return [historyAttributedString copy];
    }
}

@end
