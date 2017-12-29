//
//  AMTableViewController.h
//  29UITableViewStatic
//
//  Created by Admin on 06.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateOfBirthDatePicker;
@property (weak, nonatomic) IBOutlet UISwitch *enableNotificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allTextFields;

- (IBAction)actionValueChangedControls:(id)sender;


@end
