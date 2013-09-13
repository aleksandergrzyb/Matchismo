//
//  SetCardView.h
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/14/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SetCardView : UIView

// Use below values to create set card

#define DIAMOND 1.0
#define SQUIGGLE 2.0
#define OVAL 3.0

#define SOLID 4.0
#define STRIPED 5.0
#define OPEN 6.0

#define RED_COLOR 7.0
#define GREEN_COLOR 8.0
#define PURPLE_COLOR 9.0

#define MIN_NUMBER 1.0
#define MAX_NUMBER 3.0

@property (nonatomic) int symbol;
@property (nonatomic) int color;
@property (nonatomic) int shading;
@property (nonatomic) int number;
@property (nonatomic) BOOL faceUp;

@end
