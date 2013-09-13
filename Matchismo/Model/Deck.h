//
//  Deck.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/2/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;

@end
