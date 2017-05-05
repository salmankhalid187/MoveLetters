//
//  MovingLabel.m
//  MoveLetters
//
//  Created by Salman Khalid on 19/09/2015.
//  Copyright (c) 2015 Salman Khalid. All rights reserved.
//

#import "MovingLabel.h"

@implementation MovingLabel

@synthesize _delegate;

-(void)awakeFromNib  {
    
    [self AddPanGesture];
}

-(id)initWithFrame:(CGRect)frame    {
    
    if(self = [super initWithFrame:frame])
    {
        [self AddPanGesture];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setUserInteractionEnabled:YES];
        [self setTextColor:[UIColor blackColor]];
        [self setFont:[UIFont systemFontOfSize:24]];
    }
    return self;
}

-(void)AddPanGesture    {
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self addGestureRecognizer:panRecognizer];

}

-(void)move:(id)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.superview];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
    }
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    
    [[sender view] setCenter:translatedPoint];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        CGFloat finalX = translatedPoint.x + (0*[(UIPanGestureRecognizer*)sender velocityInView:self].x);
        CGFloat finalY = translatedPoint.y + (0*[(UIPanGestureRecognizer*)sender velocityInView:self].y);
        
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        
        [_delegate draggingEnded:self firstX:firstX ndFirstY:firstY];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer   {
    [self.superview bringSubviewToFront:self];
    return true;
}



@end
