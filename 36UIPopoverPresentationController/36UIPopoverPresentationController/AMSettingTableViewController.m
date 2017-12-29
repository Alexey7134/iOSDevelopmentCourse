//
//  AMSettingTableViewController.m
//  36UIPopoverPresentationController
//
//  Created by Admin on 20.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMSettingTableViewController.h"
#import "AMAboutViewController.h"
#import "AMDatePickerViewController.h"
#import "AMEducationTableViewController.h"

static NSString* kFirstNameTextField = @"kFirstNameTextField";
static NSString* kLastNameTextField = @"kLastNameTextField";
static NSString* kGenderSegmentedControl = @"kGenderSegmentedControl";
static NSString* kDateOfBirthTextField = @"kDateOfBirthTextField";
static NSString* kEducationTextField = @"kEducationTextField";

typedef enum {
    AMEducationTypeBasic,
    AMEducationTypeIncompleteSecondary,
    AMEducationTypeSecondary,
    AMEducationTypeIncompleteHigher,
    AMEducationTypeHigher,
    AMEducationTypeMagistracy
} AMEducationType;

@interface AMSettingTableViewController () <UITextFieldDelegate, UIPopoverPresentationControllerDelegate, AMDatePickerViewControllerDelegate, AMEducationTableViewDelegate>

@property (strong, nonatomic) AMAboutViewController* aboutViewController;
@property (strong, nonatomic) AMDatePickerViewController* datePickerViewController;
@property (strong, nonatomic) AMEducationTableViewController* educationTableViewController;
@property (strong, nonatomic) UIPopoverPresentationController* presentationViewController;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;

@end

@implementation AMSettingTableViewController

#pragma mark - View lifecycle

- (void) viewDidLoad {
    
    for (UITextField* textField in self.allTextFields) {
        textField.delegate = self;
    }
    
    [self loadSetting];
    
    [[self.allTextFields firstObject] becomeFirstResponder];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    if ([self.dateOfBirthTextField isEqual:@""]) {
        self.dateOfBirthTextField.text = [self.dateFormatter stringFromDate:[NSDate date]];
    }
    
}
#pragma mark - Save/Load

- (void) saveSetting {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* keys = [[NSArray alloc] initWithObjects:kFirstNameTextField, kLastNameTextField, kDateOfBirthTextField, kEducationTextField,  nil];
    
    for (NSInteger i = 0; i < [self.allTextFields count]; i++) {
        
        UITextField* field = [self.allTextFields objectAtIndex:i];
        [userDefaults setObject:field.text forKey:[keys objectAtIndex:i]];
        
    }
    
    [userDefaults setInteger:self.genderSegmentedControl.selectedSegmentIndex forKey:kGenderSegmentedControl];
    
    [userDefaults synchronize];
    
}

- (void) loadSetting {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* keys = [[NSArray alloc] initWithObjects:kFirstNameTextField, kLastNameTextField, kDateOfBirthTextField, kEducationTextField,  nil];
    
    for (NSInteger i = 0; i < [self.allTextFields count]; i++) {
        
        UITextField* field = [self.allTextFields objectAtIndex:i];
        field.text = [userDefaults objectForKey:[keys objectAtIndex:i]];
        
    }
    
    self.genderSegmentedControl.selectedSegmentIndex = [userDefaults integerForKey:kGenderSegmentedControl];
    
}

#pragma mark - Methods

- (void) releasePresentationControllers {
    
    self.aboutViewController = nil;
    self.datePickerViewController = nil;
    self.educationTableViewController = nil;
    self.presentationViewController = nil;
    
}

- (NSInteger) indexForEducationString:(NSString*)string {

    NSArray* educationArray = [self educationDataSource];
    
    for (NSString* education in educationArray) {
        if ([education isEqualToString:string]) {
            return [educationArray indexOfObject:education];
        }
    }
    
    return 0;
    
}

- (NSString*) stringWithEducationType:(AMEducationType)type {
    
    NSString* stringType = nil;
    
    switch (type) {
        case AMEducationTypeBasic:
            stringType = @"Basic";
            break;
        case AMEducationTypeIncompleteSecondary:
            stringType = @"Incomplete secondary";
            break;
        case AMEducationTypeSecondary:
            stringType = @"Secondary";
            break;
        case AMEducationTypeIncompleteHigher:
            stringType = @"Incomplete higher";
            break;
        case AMEducationTypeHigher:
            stringType = @"Higher";
            break;
        case AMEducationTypeMagistracy:
            stringType = @"Magistracy";
            break;
    }
    return stringType;

}

- (NSArray*) educationDataSource {
    
    NSMutableArray* dataSource = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 6; i++) {
        [dataSource addObject:[self stringWithEducationType:(AMEducationType)i]];
    }
    
    return dataSource;
    
}

- (UIPopoverPresentationController*) showPopoverFromController:(UIViewController*)viewController withAnchorBarButtonItem:(UIBarButtonItem*)barButtonItem orWithAnchorView:(UIView*)view {
    
    UIPopoverPresentationController* popoverController  = [viewController popoverPresentationController];
    popoverController.backgroundColor = [UIColor lightGrayColor];
    popoverController.delegate = self;
    
    if (barButtonItem != nil) {
        popoverController.barButtonItem = barButtonItem;
    } else if (view != nil) {
        popoverController.sourceView = self.view;
        popoverController.sourceRect = [view convertRect:view.bounds toView:self.view];
    }
    
    return popoverController;
}

#pragma mark - Actions

- (IBAction)actionValueChangedGenderSegmentedControl:(UISegmentedControl *)sender {
    
    [self saveSetting];
    
}

- (IBAction)actionInfoBarButtonItem:(UIBarButtonItem *)sender {
    
    self.aboutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMAboutViewController"];

    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:self.aboutViewController];
    navigationController.modalPresentationStyle = UIModalPresentationPopover;
    navigationController.preferredContentSize = CGSizeMake(MIN(CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds)) / 3, MIN(CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds)) / 3);
    
    UIBarButtonItem* doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDoneBarButtonItem:)];
    self.aboutViewController.navigationItem.leftBarButtonItem = doneBarButtonItem;
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     
        self.presentationViewController = [self showPopoverFromController:navigationController withAnchorBarButtonItem:self.infoBarButtonItem orWithAnchorView:nil];
        
    }
    
}

- (void) actionDoneBarButtonItem:(UIBarButtonItem*)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self releasePresentationControllers];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.presentationViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self releasePresentationControllers];
        
    }
    
    if ([textField isEqual:self.dateOfBirthTextField]) {
        
        self.datePickerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMDatePickerViewController"];
        
        UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:self.datePickerViewController];
        navigationController.modalPresentationStyle = UIModalPresentationPopover;
        navigationController.preferredContentSize = CGSizeMake(MIN(CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds)) / 2, MIN(CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds)) / 3);
        
        UIBarButtonItem* doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDoneBarButtonItem:)];
        
        self.datePickerViewController.navigationItem.leftBarButtonItem = doneBarButtonItem;
        self.datePickerViewController.date = [self.dateFormatter dateFromString:textField.text];
        self.datePickerViewController.delegate = self;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            self.presentationViewController = [self showPopoverFromController:navigationController withAnchorBarButtonItem:nil orWithAnchorView:textField];
            
        }
        
        return NO;
        
    } else if ([textField isEqual:self.educationTextField]) {
        
        self.educationTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMEducationTableViewController"];
        
        UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:self.educationTableViewController];
        navigationController.modalPresentationStyle = UIModalPresentationPopover;
        navigationController.preferredContentSize = CGSizeMake(MIN(CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds)) / 2, MIN(CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds)) / 3);
        
        UIBarButtonItem* doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDoneBarButtonItem:)];
        
        self.educationTableViewController.navigationItem.leftBarButtonItem = doneBarButtonItem;
        self.educationTableViewController.dataSource = [self  educationDataSource];
        self.educationTableViewController.indexSelectedRow = [self indexForEducationString:textField.text];
        self.educationTableViewController.delegate = self;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

            self.presentationViewController = [self showPopoverFromController:navigationController withAnchorBarButtonItem:nil orWithAnchorView:textField];
            
        }
        
        return NO;
        
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    [self saveSetting];
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.firstNameTextField]) {
        [self.lastNameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.lastNameTextField]) {
        [textField resignFirstResponder];
    }
    
    [self saveSetting];
    
    return YES;
    
}

#pragma mark - AMEducationTableViewDelegate

- (void) didSelectRowAtIndex:(NSInteger)index {
    
    self.educationTextField.text = [self stringWithEducationType:(AMEducationType)index];
    [self saveSetting];
    
}

#pragma mark - AMDatePickerViewControllerDelegate

- (void) didValueChangedDatePicker:(UIDatePicker *)datePicker {
    
    self.dateOfBirthTextField.text = [self.dateFormatter stringFromDate:datePicker.date];
    [self saveSetting];
    
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    [self releasePresentationControllers];
    
}

@end
