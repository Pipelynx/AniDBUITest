//
//  PLRatingView.m
//  AniDBUITest
//
//  Created by Martin Fellner on 31.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "PLRatingView.h"

@implementation PLRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    _rating = 0.0f;
    _maxRating = 5;
    _step = 0.5f;
    _editable = YES;
    _delegate = nil;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGFloat starWidth = self.bounds.size.width / _maxRating;
    CGFloat starHeight = self.bounds.size.height;
    
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextFillRect(ctx, self.bounds);
    CGContextSetLineWidth(ctx, 0.1f);
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    for (int i = floorf(_rating); i < _maxRating; i++)
        [self drawStarInContext:ctx inRect:CGRectMake(starWidth * i, 0, starWidth, starHeight)];
    CGContextClipToRect(ctx, CGRectMake(0, 0, starWidth * _rating, starHeight));
    CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
    for (int i = 0; i <= _rating; i++)
        [self drawStarInContext:ctx inRect:CGRectMake(starWidth * i, 0, starWidth, starHeight)];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void)drawStarInContext:(CGContextRef)c inRect:(CGRect)rect {
    CGContextMoveToPoint(c,    (0.50f * rect.size.width) + rect.origin.x, (0.00f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (0.60f * rect.size.width) + rect.origin.x, (0.40f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (1.00f * rect.size.width) + rect.origin.x, (0.40f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (0.68f * rect.size.width) + rect.origin.x, (0.62f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (0.82f * rect.size.width) + rect.origin.x, (1.00f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (0.50f * rect.size.width) + rect.origin.x, (0.75f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (0.18f * rect.size.width) + rect.origin.x, (1.00f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (0.32f * rect.size.width) + rect.origin.x, (0.62f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (0.00f * rect.size.width) + rect.origin.x, (0.40f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (0.40f * rect.size.width) + rect.origin.x, (0.40f * rect.size.height) + rect.origin.y);
    CGContextAddLineToPoint(c, (0.50f * rect.size.width) + rect.origin.x, (0.00f * rect.size.height) + rect.origin.y);
    CGContextFillPath(c);
    CGContextBeginPath(c);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(15.0f * _maxRating, 15.0f);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.editable)
        [self.delegate ratingView:self didChangeRating:self.rating];
}

- (void)handleTouchAtLocation:(CGPoint)touchLocation {
    if (!self.editable) return;
    
    float newRating = touchLocation.x / self.bounds.size.width * _maxRating;
    newRating = MIN(MAX(0, newRating), _maxRating);
    
    if (_step > 0 && _step < _maxRating) {
        float steppedRating = 0.0f;
        while (steppedRating < newRating)
            steppedRating += _step;
        self.rating = steppedRating;
    }
    else
        self.rating = newRating;
    
    [self setNeedsDisplay];
}

@end
