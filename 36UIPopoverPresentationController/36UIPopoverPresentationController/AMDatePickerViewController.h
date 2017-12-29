//
//  AMDatePickerViewController.h
//  36UIPopoverPresentationController
//
//  Created by Admin on 22.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMDatePickerViewControllerDelegate;

@interface AMDatePickerViewController : UIViewController

@property (strong, nonatomic) NSDate* date;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)actionValueChangedDatePicker:(UIDatePicker *)sender;

@property (weak,nonatomic) id <AMDatePickerViewControllerDelegate> delegate;

@end

@protocol AMDatePickerViewControllerDelegate <NSObject>

@optional

- (void) didValueChangedDatePicker:(UIDatePicker*)datePicker;

@end