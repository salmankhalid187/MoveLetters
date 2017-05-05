//
//  ViewController.m
//  MoveLetters
//
//  Created by Salman Khalid on 19/09/2015.
//  Copyright (c) 2015 Salman Khalid. All rights reserved.
//

#import "ViewController.h"

// Configurations
#define k_LETTER_WIDTH                  21.f
#define k_LETTER_HEIGHT                 18.f
#define K_FONT_SIZE                     18.0f
#define k_LETTER_SPACING                10.f


#define k_LETTER_GRID_WIDTH             15.f
#define k_LETTER_GRID_HEIGHT            13.f
#define K_GRID_FONT_SIZE                15.0f

#define k_LETTER_GRID_SPACING           1.f

#define k_BELOW_SPACE_LETTER_COUNT      550
#define k_INSTRUCTION_LABEL_HEIGHT      70.f
#define k_INSTRUCTION_LABEL_MARGIN      20.f
#define k_INTIAL_X_MARGIN               20.f

#define K_LETTERS_GRID_VIEW_TAG         777
#define k_GRID_VIEW_TAG                 999
#define k_LETTERS_TAG                   888


#define k_INSTRUCTION_TEXT              @"Move letters from above to create words or phrases below"


@interface ViewController ()    {
    NSMutableArray *lettersArray;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // letters file as starting data
    lettersArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Letters" ofType:@"plist"]];
    
    [self setUpLetters];
}


-(void)setUpLetters {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    float initialYPosition = self.startInstructionLabel.frame.origin.y + self.startInstructionLabel.frame.size.height + 20.0f;
    
    int numberOfLettersPerRow = (screenWidth) / (k_LETTER_WIDTH + k_LETTER_SPACING);
    
    int rowNumber = 0;
    int columnNumber = 0;
    
    int currentXPosition = 0;
    int currentYPosition = 0;
    
    
    for (int i=0; i< lettersArray.count; i++)
    {
        NSString *tempLetter = [lettersArray objectAtIndex:i];
        
        currentXPosition = (k_LETTER_WIDTH * columnNumber) + (k_LETTER_SPACING * columnNumber) + k_LETTER_SPACING;
        currentYPosition = (k_LETTER_HEIGHT * rowNumber) + (k_LETTER_SPACING * rowNumber) + initialYPosition;
        UIView *gridCell = [[UIView alloc] initWithFrame:CGRectMake(currentXPosition, currentYPosition, k_LETTER_WIDTH, k_LETTER_HEIGHT)];
        gridCell.tag = K_LETTERS_GRID_VIEW_TAG;
        [gridCell setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:gridCell];
        
        MovingLabel *movingLabel = [[MovingLabel alloc] initWithFrame:CGRectMake(currentXPosition, currentYPosition, k_LETTER_WIDTH, k_LETTER_HEIGHT)];
        movingLabel._delegate = self;
        movingLabel.tag = k_LETTERS_TAG;
        [movingLabel setFont:[UIFont fontWithName:@"Helvetica" size:K_FONT_SIZE]];
        [movingLabel setBackgroundColor:[UIColor clearColor]];
        [movingLabel setText:tempLetter];
        [self.view addSubview:movingLabel];
        
        if((i+1) % numberOfLettersPerRow == 0)
        {
            rowNumber ++;
            columnNumber = 0;
        }
        else
        {
            columnNumber ++;
        }
        
    }
    
    
    [self addInstructionText:currentYPosition + k_LETTER_HEIGHT + k_LETTER_SPACING andWidth:screenWidth];
    
    [self setUpGrid:currentYPosition + k_LETTER_WIDTH + k_LETTER_SPACING + k_INSTRUCTION_LABEL_HEIGHT+k_INSTRUCTION_LABEL_MARGIN];
}

- (void)addInstructionText:(float)yPos andWidth:(float)width
{
    
    UILabel *staticLabel = [[UILabel alloc] initWithFrame:CGRectMake(k_INTIAL_X_MARGIN, yPos, width - k_INTIAL_X_MARGIN, k_INSTRUCTION_LABEL_HEIGHT)];
    [staticLabel setText:k_INSTRUCTION_TEXT];
    [staticLabel setNumberOfLines:2];
    [staticLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:staticLabel];
    
    UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPos + k_INSTRUCTION_LABEL_HEIGHT + 5, width, 1)];
    [separatorLine setBackgroundColor:[UIColor grayColor]];
    
    [self.view addSubview:separatorLine];
}

/*
 This function will setup grid that will help to accomodate all the letters. Each letter will be added to grid cell and smooth animation will adjust if letter is not properly.
 Grid is being used to properly create layout and lines.
 It can work without grid but then space will be messy.
 */
-(void)setUpGrid:(float)_YPosition    {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    float initialYPosition = _YPosition;
    
    float width = k_LETTER_GRID_WIDTH;
    float height = k_LETTER_GRID_HEIGHT;
    float interLetterDistance = k_LETTER_GRID_SPACING;
    
    int numberOfLettersPerRow = (screenWidth) / (width + interLetterDistance);  //max letters per row
    
    
    int rowNumber = 0;
    int columnNumber = 0;
    
    int currentXPosition = 0;
    int currentYPosition = 0;
    
    float  startingYPositionOfGrid = (height * rowNumber) + (interLetterDistance * rowNumber) + initialYPosition;
    float heightLeft = screenHeight - startingYPositionOfGrid;
    int numberOfRows = (heightLeft / k_LETTER_GRID_HEIGHT) - ((heightLeft / k_LETTER_GRID_HEIGHT)/(k_LETTER_GRID_HEIGHT+k_LETTER_GRID_SPACING));  //subtracting margin to adjust the spacing
    
    
    for (int i=0; i< numberOfRows*numberOfLettersPerRow; i++)  // this will give total number of grid cell to accomodate letters
    {
        
        currentXPosition = (width * columnNumber) + (interLetterDistance * columnNumber) + interLetterDistance;
        currentYPosition = (height * rowNumber) + (interLetterDistance * rowNumber) + initialYPosition;
        
        UIView *gridCell = [[UIView alloc] initWithFrame:CGRectMake(currentXPosition, currentYPosition, width, height)];
        [gridCell setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:gridCell];
        [self.view sendSubviewToBack:gridCell];
        
        gridCell.tag = k_GRID_VIEW_TAG;
        if((i+1) % numberOfLettersPerRow == 0)
        {
            rowNumber ++;
            columnNumber = 0;
        }
        else
        {
            columnNumber ++;
        }
    }
}

#pragma mark --
#pragma mark Moving Label Delegate Methods

-(void)draggingEnded:(id)_label firstX:(CGFloat)_startX ndFirstY:(CGFloat)_startY    {
    
    MovingLabel *mLbl = (MovingLabel *)_label;
    [self.view bringSubviewToFront:mLbl];

    NSArray *subViews = [self.view subviews];
    
    float gridOverlapSize = 0.0f;
    float letterOverlapSize = 0.0f;
    
    UIView *overlappedView;
    BOOL isMovingFromStaticToPlayArea = false;
    for (UIView *tempView in subViews)
    {
        CGRect overlapFrame = CGRectIntersection(mLbl.frame, tempView.frame);
        float overlapSize = overlapFrame.size.width * overlapFrame.size.height;
        
        if(tempView.tag == k_GRID_VIEW_TAG)
        {
            if(overlapSize > gridOverlapSize)
            {
                overlappedView = tempView;
                gridOverlapSize = overlapSize;
                isMovingFromStaticToPlayArea = true;
            }
        }
        else if (tempView.tag == K_LETTERS_GRID_VIEW_TAG)
        {
            if(overlapSize > gridOverlapSize)
            {
                overlappedView = tempView;
                gridOverlapSize = overlapSize;
                isMovingFromStaticToPlayArea = false;
            }
        }
        else if (tempView.tag == k_LETTERS_TAG)
        {
            
            if(overlapSize > 0.0)
            {
                if(![tempView isEqual:mLbl])
                {
                    if(overlapSize > letterOverlapSize)
                    {
                        letterOverlapSize = overlapSize;
                        isMovingFromStaticToPlayArea = false;
                    }
                }
            }
        }
    }
    
    if(gridOverlapSize > 0.0 && overlappedView != nil && gridOverlapSize > letterOverlapSize)
    {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [mLbl setFrame:overlappedView.frame];
                             if(isMovingFromStaticToPlayArea)
                             {
                                [mLbl setFont:[UIFont fontWithName:@"Helvetica" size:K_GRID_FONT_SIZE]];
                             }
                             else{
                                [mLbl setFont:[UIFont fontWithName:@"Helvetica" size:K_FONT_SIZE]];
                             }
                             [self.view bringSubviewToFront:mLbl];
                         }
                         completion:^(BOOL finished) {
                             //here we can add ant alert or instruction on animation end
                             
                         }];
        
    }
    
    else
    {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [mLbl setCenter:CGPointMake(_startX, _startY)];
                             [self.view bringSubviewToFront:mLbl];
                         }
                         completion:^(BOOL finished) {
                             //here we can add ant alert or instruction on animation end
                             
                         }];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
