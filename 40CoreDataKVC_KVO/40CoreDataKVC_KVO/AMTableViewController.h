//
//  AMTableViewController.h
//  40CoreDataKVC_KVO
//
//  Created by Admin on 02.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *gradeTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeBarButtonItem;

- (IBAction)actionEditingChangedFirstNameTextField:(UITextField *)sender;
- (IBAction)actionEditingChangedLastNameTextField:(UITextField *)sender;
- (IBAction)actionEditingChangedGradeTextField:(UITextField *)sender;
- (IBAction)actionValueChangedGenderSegmentedControl:(UISegmentedControl *)sender;
- (IBAction)actionPreviousBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)actionNextBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)actionAddBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)actionRemoveBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)actionResetBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)actionInfoBarButtonItem:(UIBarButtonItem *)sender;


@end
