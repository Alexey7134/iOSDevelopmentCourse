//
//  ViewController.h
//  25UIControls
//
//  Created by Admin on 28.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstComponentLabel;
@property (weak, nonatomic) IBOutlet UIButton *equalButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;

- (IBAction)actionUpInsideDigitalButton:(UIButton *)sender;
- (IBAction)actionUpInsideSignButton:(UIButton *)sender;
- (IBAction)actionUpInsideOperationButton:(UIButton *)sender;
- (IBAction)actionUpInsideSeparatorButton:(UIButton *)sender;

@end

