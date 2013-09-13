//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/12/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
