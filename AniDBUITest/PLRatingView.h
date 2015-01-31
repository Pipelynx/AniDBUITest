//
//  PLRatingView.h
//  AniDBUITest
//
//  Created by Martin Fellner on 31.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLRatingView;

@protocol PLRatingViewDelegate

- (void)ratingView:(PLRatingView *)ratingView didChangeRating:(float)rating;

@end

IB_DESIGNABLE
@interface PLRatingView : UIView

@property (assign, nonatomic) IBInspectable float rating;
@property (assign, nonatomic) IBInspectable int maxRating;
@property (assign, nonatomic) IBInspectable float step;
@property (assign, nonatomic) IBInspectable BOOL editable;
@property (assign, nonatomic) id <PLRatingViewDelegate> delegate;

@end
