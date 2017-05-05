//
//  ViewController.h
//  MoveLetters
//
//  Created by Salman Khalid on 19/09/2015.
//  Copyright (c) 2015 Salman Khalid. All rights reserved.
///

#import <UIKit/UIKit.h>
#import "MovingLabel.h"

@interface ViewController : UIViewController <MovingLabelDelegate>    {
 
}
@property (weak, nonatomic) IBOutlet UILabel *startInstructionLabel;


@end

