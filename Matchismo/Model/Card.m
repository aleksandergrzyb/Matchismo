//
//  Card.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/2/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

- (NSString *)description
{
    return self.contents;
}

@end
