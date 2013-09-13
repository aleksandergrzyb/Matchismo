//
//  PlayingCard.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/2/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
