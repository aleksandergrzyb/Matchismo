//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/11/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) SEL sortSelector;
@end

@implementation GameResultViewController

@synthesize sortSelector = _sortSelector;

- (SEL)sortSelector
{
    if (!_sortSelector) {
        _sortSelector = @selector(compareScoreToGameResult:);
    }
    return _sortSelector;
}

- (void)setSortSelector:(SEL)sortSelector
{
    _sortSelector = sortSelector;
    [self updateUI];
}

- (void)updateUI
{
    NSString *displayText = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    for (GameResult *gameResult in [[GameResult allGameResults] sortedArrayUsingSelector:self.sortSelector]) {
        displayText = [displayText stringByAppendingFormat:@"%@ - Score: %d, Time: %@, Duration: %d\n",gameResult.gameType, gameResult.score, [dateFormatter stringFromDate:gameResult.end], (int)round(gameResult.duration)];
    }
    self.display.text = displayText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (IBAction)clearPressed
{
    [GameResult resetUserDefaults];
    [self updateUI];
}

- (IBAction)sortByDuration
{
    self.sortSelector = @selector(compareDurationToGameResult:);
}

- (IBAction)sortByScore
{
    self.sortSelector = @selector(compareScoreToGameResult:);
}

- (IBAction)sortByDate
{
    self.sortSelector = @selector(compareEndDateToGameResult:);
}

- (IBAction)sortByType
{
    self.sortSelector = @selector(compareGameTypeToGameResult:);
}

@end
