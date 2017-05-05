//
//  MovingLabel.h
//  MoveLetters
//
//  Created by Salman Khalid on 19/09/2015.
//  Copyright (c) 2015 Salman Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MovingLabelDelegate <NSObject>

-(void)draggingEnded:(id)_label firstX:(CGFloat)_startX ndFirstY:(CGFloat)_startY;

@end

@interface MovingLabel : UILabel  <UIGestureRecognizerDelegate>  {
    
    CGFloat firstX;
    CGFloat firstY;
    
    id <MovingLabelDelegate> _delegate;

}

@property (nonatomic, retain) id <MovingLabelDelegate> _delegate;

-(id)initWithFrame:(CGRect)frame;

@end
