//
//  AMSettingTableViewController.h
//  36UIPopoverPresentationController
//
//  Created by Admin on 20.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSettingTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoBarButtonItem;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UITextField *educationTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *allTextFields;

- (IBAction)actionValueChangedGenderSegmentedControl:(UISegmentedControl *)sender;
- (IBAction)actionInfoBarButtonItem:(UIBarButtonItem *)sender;

@end
