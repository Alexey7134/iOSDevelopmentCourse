//
//  AMDatePickerViewController.m
//  36UIPopoverPresentationController
//
//  Created by Admin on 22.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDatePickerViewController.h"

@implementation AMDatePickerViewController

#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.date != nil) {
        self.datePicker.date = self.date;
    }
    
}

#pragma mark - Actions

- (IBAction)actionValueChangedDatePicker:(UIDatePicker *)sender {
    
    [self.delegate didValueChangedDatePicker:sender];
    
}

@end

