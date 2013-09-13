//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/12/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) BOOL faceUp;

@end
