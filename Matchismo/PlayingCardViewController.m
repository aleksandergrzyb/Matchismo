//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/12/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@implementation PlayingCardViewController

#define NUMBER_OF_PLAYING_CARDS 22

- (NSUInteger)startingCardCount
{
    return NUMBER_OF_PLAYING_CARDS;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}


- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card withAnimation:(BOOL)animated;
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            if (!card.isUnplayable) {
                if (animated) {
                    [UIView transitionWithView:playingCardView
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionFlipFromLeft
                                    animations:^{
                                        playingCardView.rank = playingCard.rank;
                                        playingCardView.suit = playingCard.suit;
                                        playingCardView.faceUp = playingCard.isFaceUp;
                                    }
                                    completion:NULL];
                } else {
                    playingCardView.rank = playingCard.rank;
                    playingCardView.suit = playingCard.suit;
                    playingCardView.faceUp = playingCard.isFaceUp;
                }

            } else {
                playingCardView.rank = playingCard.rank;
                playingCardView.suit = playingCard.suit;
                playingCardView.faceUp = YES;
            }
        }
    }
}

- (NSAttributedString *)historyInformation
{
    if (![self matchingInformation]) {
        return [[[NSAttributedString alloc] initWithString:@""] copy];
    } else {
        NSMutableAttributedString *historyAttributedString = [[NSMutableAttributedString alloc] initWithString:[self matchingInformation]];
        NSRange range = [[self matchingInformation] rangeOfString:[self matchingInformation]];
        UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
        NSParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle];
        NSMutableParagraphStyle *mutableStyle = [style mutableCopy];
        mutableStyle.alignment = NSTextAlignmentCenter;
        [historyAttributedString addAttributes:@{NSFontAttributeName : font} range:range];
        [historyAttributedString addAttributes:@{NSParagraphStyleAttributeName : [mutableStyle copy]} range:range];
        return [historyAttributedString copy];
    }
}

- (int)gameType
{
    return PLAYING_CARD_GAME;
}

- (int)gameMode
{
    return TWO_CARD_MODE;
}

@end
