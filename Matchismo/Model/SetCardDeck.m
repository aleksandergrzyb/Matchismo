//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/10/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    if (self) {
        for (NSNumber *symbol in [SetCard validSymbols]) {
            for (NSNumber *color in [SetCard validColors]) {
                for (NSNumber *shading in [SetCard validShadings]) {
                    for (int number = 1; number <= [SetCard maxNumber]; number++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.shading = [shading intValue];
                        card.color = [color intValue];
                        card.symbol = [symbol intValue];
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}


@end
