//
//  Card.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/2/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;

@end
