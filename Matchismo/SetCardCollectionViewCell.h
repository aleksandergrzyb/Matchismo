//
//  SetCardCollectionViewCell.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/15/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCardView.h"

@interface SetCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@end
