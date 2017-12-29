//
//  AMDatePickerController.h
//  40CoreDataKVC_KVO
//
//  Created by Admin on 03.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMDatePickerControllerDelegate;

@interface AMDatePickerController : UIViewController

@property (strong, nonatomic) NSDate* date;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)actionValueChangedDatePicker:(UIDatePicker *)sender;

@property (weak,nonatomic) id <AMDatePickerControllerDelegate> delegate;

@end

@protocol AMDatePickerControllerDelegate <NSObject>

@optional

- (void) didValueChangedDatePicker:(UIDatePicker*)datePicker;

@end
