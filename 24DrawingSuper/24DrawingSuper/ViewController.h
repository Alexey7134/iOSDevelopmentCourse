//
//  ViewController.h
//  24DrawingSuper
//
//  Created by Admin on 27.09.17.
//  Copyright © 2017 AMiksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMDrawingView;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet AMDrawingView* drawingView;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIView *brushView;
@property (weak, nonatomic) IBOutlet UISlider *sizeBrushSlider;

@end

