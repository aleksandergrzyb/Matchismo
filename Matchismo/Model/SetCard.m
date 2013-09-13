//
//  SetCard.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/10/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (void)setNumber:(int)number
{
    if (number <= [SetCard maxNumber] && number > 0) {
        _number = number;
    }
}

- (void)setShading:(int)shading
{
    if ([[SetCard validShadings] containsObject:[NSNumber numberWithInt:shading]]) {
        _shading = shading;
    }
}

- (void)setColor:(int)color
{
    if ([[SetCard validColors] containsObject:[NSNumber numberWithInt:color]]) {
        _color = color;
    }
}

- (void)setSymbol:(int)symbol
{
    if ([[SetCard validSymbols] containsObject:[NSNumber numberWithInt:symbol]]) {
        _symbol = symbol;
    }
}

- (NSString *)nameForSymbol:(BOOL)plural
{
    NSString *name;
    if (self.symbol == OVAL) {
        name = @"Oval";
    } else if (self.symbol == SQUIGGLE) {
        name = @"Squiggle";
    } else if (self.symbol == DIAMOND) {
        name = @"Diamond";
    }
    if (plural) {
        return [NSString stringWithFormat:@"%@s", name];
    } else {
        return name;
    }
}

- (NSString *)contents
{

    if (self.number == 1) {
        return [NSString stringWithFormat:@"%@", [self nameForSymbol:NO]];
    } else {
        return [NSString stringWithFormat:@"%d %@", self.number, [self nameForSymbol:YES]];
    }
}

+ (NSArray *)validSymbols
{
    static NSArray* validSymbols = nil;
    if (!validSymbols) {
        validSymbols = @[@(DIAMOND), @(SQUIGGLE), @(OVAL)];
    }
    return validSymbols;
}

+ (NSArray *)validColors
{
    static NSArray* validColors = nil;
    if (!validColors) {
        validColors = @[@(RED_COLOR), @(GREEN_COLOR), @(PURPLE_COLOR)];
    }
    return validColors;
}

+ (NSArray *)validShadings
{
    static NSArray* validShadings = nil;
    if (!validShadings) {
        validShadings = @[@(STRIPED), @(SOLID), @(OPEN)];
    }
    return validShadings;
}

+ (int)maxNumber
{
    return MAX_NUMBER;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int match = 0;
    
    if (otherCards.count == 2) {
        SetCard *firstCard = otherCards[0];
        SetCard *secondCard = otherCards[1];
        if (self.color == firstCard.color && self.color == secondCard.color && firstCard.color == secondCard.color) {
            match += 1;
        } else if (self.color != firstCard.color && self.color != secondCard.color && firstCard.color != secondCard.color) {
            match += 1;
        }
        
        if (self.number == firstCard.number && self.number == secondCard.number && firstCard.number == secondCard.number) {
            match += 1;
        } else if (self.number != firstCard.number && self.number != secondCard.number && firstCard.number != secondCard.number) {
            match += 1;
        }
        
        if (self.shading == firstCard.shading && self.shading == secondCard.shading && firstCard.shading == secondCard.shading) {
            match += 1;
        } else if (self.shading != firstCard.shading && self.shading != secondCard.shading && firstCard.shading != secondCard.shading) {
            match += 1;
        }
        
        if (self.symbol == firstCard.symbol && self.symbol == secondCard.symbol && firstCard.symbol == secondCard.symbol) {
            match += 1;
        } else if (self.symbol != firstCard.symbol && self.symbol != secondCard.symbol && firstCard.symbol != secondCard.symbol) {
            match += 1;
        }
        
        if (match == 4) score = 4;
    }
    return score;
}

@end
