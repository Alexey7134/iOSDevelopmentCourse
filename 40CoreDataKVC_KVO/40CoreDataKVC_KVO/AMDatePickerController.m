//
//  AMDatePickerController.m
//  40CoreDataKVC_KVO
//
//  Created by Admin on 03.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDatePickerController.h"

@implementation AMDatePickerController

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
