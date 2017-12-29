//
//  ViewController.h
//  26Controls
//
//  Created by Admin on 02.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet UISwitch *rotationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *scaleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *TranslationSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *imageSegmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *allLabels;


- (IBAction)actionValueChangedSwitch:(UISwitch *)sender;
- (IBAction)actionValueChangedImageSegmentedControl:(UISegmentedControl *)sender;


@end

