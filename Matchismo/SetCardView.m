//
//  SetCardView.m
//  Matchismo
//
//  Created by Aleksander Grzyb on 7/14/13.
//  Copyright (c) 2013 Aleksander Grzyb. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (strong, nonatomic) NSMutableArray *symbolRects;
@end

@implementation SetCardView

#define CARD_CORNER_RADIUS 5.0
#define SYMBOL_HEIGHT_SCALE_FACTOR 0.2
#define SYMBOL_WIDTH_SCALE_FACTOR 0.8

- (void)setColor:(int)color
{
    if (color == RED_COLOR || color == GREEN_COLOR || color == PURPLE_COLOR) {
        _color = color;
    } else {
        _color = RED_COLOR;
    }
    [self setNeedsDisplay];
}

- (void)setNumber:(int)number
{
    if (number >= MIN_NUMBER && number <= MAX_NUMBER) {
        _number = number;
    } else {
        _number = MIN_NUMBER;
    }
    [self setNeedsDisplay];
}

- (void)setSymbol:(int)symbol
{
    if (symbol == DIAMOND || symbol == SQUIGGLE || symbol == OVAL) {
        _symbol = symbol;
    } else {
        _symbol = DIAMOND;
    }
    [self setNeedsDisplay];
}

- (void)setShading:(int)shading
{
    if (shading == STRIPED || shading == SOLID || shading == OPEN) {
        _shading = shading;
    } else {
        _shading = STRIPED;
    }
    [self setNeedsDisplay];
}

- (NSMutableArray *)symbolRects
{
    if (!_symbolRects) {
        _symbolRects = [[NSMutableArray alloc] init];
    }
    return _symbolRects;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing background and highlighting of card
    UIBezierPath *card = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CARD_CORNER_RADIUS];
    [card addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    if (self.faceUp) {
        CGRect faceUpRect = self.bounds;
        UIBezierPath *faceUpPatch = [UIBezierPath bezierPathWithRect:faceUpRect];
        [[[UIColor yellowColor] colorWithAlphaComponent:0.7] setFill];
        [faceUpPatch fill];
    }
    // Setting frames for symbols
    CGFloat rectHeight = self.bounds.size.height * SYMBOL_HEIGHT_SCALE_FACTOR;
    CGFloat rectWidth = self.bounds.size.width * SYMBOL_WIDTH_SCALE_FACTOR;
    CGFloat horizontalEdgeOffset = (self.bounds.size.width - rectWidth) * 0.5;
    CGFloat verticalEdgeOffset = 0.0;
    CGFloat frameForRectHeight = self.bounds.size.height / self.number;
    int offset = 0;
    for (int iterator = 1; iterator <= self.number; iterator++) {
        verticalEdgeOffset = (frameForRectHeight - rectHeight) * 0.5 + offset;
        [self.symbolRects addObject:[NSValue valueWithCGRect:CGRectMake(horizontalEdgeOffset, verticalEdgeOffset, rectWidth, rectHeight)]];
        offset += frameForRectHeight;
    }
    // Drawing symbols
    if (self.symbol == OVAL) {
        [self drawOval];
    } else if (self.symbol == DIAMOND) {
        [self drawDiamond];
    } else if (self.symbol == SQUIGGLE) {
        [self drawSquiggle];
    }
}

- (void)drawSquiggle
{
    for (NSValue *rectValue in self.symbolRects) {
        CGRect currentRect = [rectValue CGRectValue];
        UIBezierPath *squigglePath = [[UIBezierPath alloc] init];
        CGFloat scaleFactorX = currentRect.size.width / 672;
        CGFloat scaleFactorY = currentRect.size.height / 312;
        [squigglePath moveToPoint:CGPointMake(currentRect.origin.x + 600.0 * scaleFactorX, currentRect.origin.y + 24.0 * scaleFactorY)];
        [squigglePath addCurveToPoint:CGPointMake(currentRect.origin.x + 72.0 * scaleFactorX, currentRect.origin.y + 96 * scaleFactorY) controlPoint1:CGPointMake(currentRect.origin.x + 336.0 * scaleFactorX,currentRect.origin.y + 240.0 * scaleFactorY) controlPoint2:CGPointMake(currentRect.origin.x + 336.0 * scaleFactorX, currentRect.origin.y - 120.0 * scaleFactorY)];
        [squigglePath addCurveToPoint:CGPointMake(currentRect.origin.x + 72.0 * scaleFactorX, currentRect.origin.y + 288.0 * scaleFactorY) controlPoint1:CGPointMake(currentRect.origin.x - 24.0 * scaleFactorX, currentRect.origin.y + 168.0 * scaleFactorY) controlPoint2:CGPointMake(currentRect.origin.x - 24.0 * scaleFactorX, currentRect.origin.y + 384.0 * scaleFactorY)];
        [squigglePath addCurveToPoint:CGPointMake(currentRect.origin.x + 600.0 * scaleFactorX,currentRect.origin.y + 216.0 * scaleFactorY) controlPoint1:CGPointMake(currentRect.origin.x + 336.0 * scaleFactorX,currentRect.origin.y + 72.0 * scaleFactorY) controlPoint2:CGPointMake(currentRect.origin.x + 336.0 * scaleFactorX, currentRect.origin.y + 432.0 * scaleFactorY)];
        [squigglePath addCurveToPoint:CGPointMake(currentRect.origin.x + 600.0 * scaleFactorX, currentRect.origin.y + 24.0 * scaleFactorY) controlPoint1:CGPointMake(currentRect.origin.x + 696.0  * scaleFactorX,currentRect.origin.y + 144.0 * scaleFactorY) controlPoint2:CGPointMake(currentRect.origin.x + 696.0 * scaleFactorX,currentRect.origin.y - 72.0 * scaleFactorY)];
        [squigglePath closePath];
        UIColor *currentColor = [self getColor];
        if (self.shading == SOLID) {
            [currentColor setFill];
            [squigglePath fill];
        } else if (self.shading == STRIPED) {
            [currentColor setStroke];
            [squigglePath stroke];
            currentColor = [currentColor colorWithAlphaComponent:0.2];
            [currentColor setFill];
            [squigglePath fill];
        } else if (self.shading == OPEN) {
            [currentColor setStroke];
            [squigglePath stroke];
        }
    }
    [self.symbolRects removeAllObjects];
}

- (void)drawDiamond
{
    for (NSValue *rectValue in self.symbolRects) {
        CGRect currentRect = [rectValue CGRectValue];
        UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
        [bezierPath moveToPoint:CGPointMake(currentRect.origin.x + currentRect.size.width * 0.5, currentRect.origin.y)];
        [bezierPath addLineToPoint:CGPointMake(currentRect.origin.x + currentRect.size.width, currentRect.origin.y + currentRect.size.height * 0.5)];
        [bezierPath addLineToPoint:CGPointMake(currentRect.origin.x + currentRect.size.width * 0.5, currentRect.origin.y + currentRect.size.height)];
        [bezierPath addLineToPoint:CGPointMake(currentRect.origin.x, currentRect.origin.y + currentRect.size.height * 0.5)];
        [bezierPath closePath];
        UIColor *currentColor = [self getColor];
        if (self.shading == SOLID) {
            [currentColor setFill];
            [bezierPath fill];
        } else if (self.shading == STRIPED) {
            [currentColor setStroke];
            [bezierPath stroke];
            currentColor = [currentColor colorWithAlphaComponent:0.2];
            [currentColor setFill];
            [bezierPath fill];
        } else if (self.shading == OPEN) {
            [currentColor setStroke];
            [bezierPath stroke];
        }
    }
    [self.symbolRects removeAllObjects];
}

- (void)drawOval
{
    for (NSValue *rectValue in self.symbolRects) {
        CGRect currentRect = [rectValue CGRectValue];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:currentRect cornerRadius:currentRect.size.height * 0.5];
        UIColor *currentColor = [self getColor];
        if (self.shading == SOLID) {
            [currentColor setFill];
            [bezierPath fill];
        } else if (self.shading == STRIPED) {
            [currentColor setStroke];
            [bezierPath stroke];
            currentColor = [currentColor colorWithAlphaComponent:0.2];
            [currentColor setFill];
            [bezierPath fill];
        } else if (self.shading == OPEN) {
            [currentColor setStroke];
            [bezierPath stroke];
        }
    }
    [self.symbolRects removeAllObjects];
}

- (UIColor *)getColor
{
    if (self.color == RED_COLOR) {
        return [UIColor redColor];
    } else if (self.color == GREEN_COLOR) {
        return [UIColor greenColor];
    } else if (self.color == PURPLE_COLOR) {
        return [UIColor purpleColor];
    } else {
        return [UIColor redColor];
    }
}

@end
