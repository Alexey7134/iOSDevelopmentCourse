//
//  AMTableViewController.m
//  40CoreDataKVC_KVO
//
//  Created by Admin on 02.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMTableViewController.h"
#import "AMStudent.h"
#import "AMDatePickerController.h"

@interface AMTableViewController () <UITextFieldDelegate, AMDatePickerControllerDelegate>

@property (strong, nonatomic) NSArray* students;
@property (strong, nonatomic) AMStudent* currentStudent;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;

@end

@implementation AMTableViewController

#pragma mark - TableView lifecycle

- (void) viewDidLoad {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSMutableArray* students = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 5; i++) {
        [students addObject:[AMStudent randomStudent]];
    }
    
    for (NSInteger i = [students count] - 2; i >= 0; i--) {
        AMStudent* student = [students objectAtIndex:i];
        student.bestFriend = [students objectAtIndex:i + 1];
    }
    
    self.students = students;
    self.currentStudent = [students lastObject];
    [self addObserverForCurrentStudent];
    
    [self.firstNameTextField becomeFirstResponder];

    [[self.students firstObject] setValue:[NSNumber numberWithFloat:5.f]
                               forKeyPath:@"bestFriend.bestFriend.bestFriend.bestFriend.grade"];
    
    [self showCurrentStudent];
    [self updateBarButtonItems];
}

#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UINavigationController* navigationController = segue.destinationViewController;
    
    AMDatePickerController* datePickerController = [[navigationController viewControllers] firstObject];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancelBarButtonItem:)];
    datePickerController.navigationItem.leftBarButtonItem = cancelButton;
    
    datePickerController.date = [self.currentStudent valueForKey:@"dateOfBirth"];
    
    datePickerController.delegate = self;
    
}

#pragma mark - Methods

- (void) showAlertWithTitle:(NSString*)title andWithMessage:(NSString*)message {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okButton];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void) addObserverForCurrentStudent {
    
    [self addObserverForCurrentStudentWithKey:@"firstName"];
    [self addObserverForCurrentStudentWithKey:@"lastName"];
    [self addObserverForCurrentStudentWithKey:@"dateOfBirth"];
    [self addObserverForCurrentStudentWithKey:@"gender"];
    [self addObserverForCurrentStudentWithKey:@"grade"];
    
}

- (void) addObserverForCurrentStudentWithKey:(NSString*)key {
    
    [self.currentStudent addObserver:self
                          forKeyPath:key
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                             context:nil];
    
}

- (void) removeObserverForCurrentStudent {
    
    [self.currentStudent removeObserver:self forKeyPath:@"firstName"];
    [self.currentStudent removeObserver:self forKeyPath:@"lastName"];
    [self.currentStudent removeObserver:self forKeyPath:@"dateOfBirth"];
    [self.currentStudent removeObserver:self forKeyPath:@"gender"];
    [self.currentStudent removeObserver:self forKeyPath:@"grade"];
    
}

- (void) reloadTableViewContentWithRowAnimation:(UITableViewRowAnimation)rowAnimation {
    
    [self.tableView beginUpdates];
    
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:0];
    
    [self.tableView reloadSections:indexSet withRowAnimation:rowAnimation];
    
    [self.tableView endUpdates];
    
    [self.tableView reloadData];
    
}

- (BOOL) canGoPreviousStudent {
    
    if (!self.currentStudent) {
        return NO;
    }
    
    if ([self.currentStudent isEqual:[self.students firstObject]]) {
        return NO;
    }
    
    return YES;
    
}

- (BOOL) canGoNextStudent {
    
    if (!self.currentStudent) {
        return NO;
    }
    
    if ([self.currentStudent isEqual:[self.students lastObject]]) {
        return NO;
    }
    
    return YES;
    
}

- (BOOL) canRemoveStudent {
    
    if ([self.students count] == 0) {
        return NO;
    }
    
    return YES;
    
}

- (void) updateBarButtonItems {
    
    self.previousBarButtonItem.enabled = [self canGoPreviousStudent];
    self.nextBarButtonItem.enabled = [self canGoNextStudent];
    self.removeBarButtonItem.enabled = [self canRemoveStudent];
    
}

- (void) setEnableTableView:(BOOL)enable {
    
    self.firstNameTextField.enabled = enable;
    self.lastNameTextField.enabled = enable;
    self.dateOfBirthTextField.enabled = enable;
    self.genderSegmentedControl.enabled = enable;
    self.gradeTextField.enabled = enable;
}

#pragma mark - Observing

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSLog(@"keyPath - %@\nofObject - %@\nchange - %@", keyPath, object, change);
    
}

#pragma mark - AMStudent

- (void) showCurrentStudent {
    
    if (self.currentStudent) {
        
        self.firstNameTextField.text = [self.currentStudent valueForKey:@"firstName"];
        self.lastNameTextField.text = [self.currentStudent valueForKey:@"lastName"];
        self.dateOfBirthTextField.text = [self.dateFormatter stringFromDate:[self.currentStudent valueForKey:@"dateOfBirth"]];
        self.genderSegmentedControl.selectedSegmentIndex = [[self.currentStudent valueForKey:@"gender"] integerValue];
        
        CGFloat grade = [[self.currentStudent valueForKey:@"grade"] floatValue];
        
        if (grade != 0) {
            self.gradeTextField.text = [NSString stringWithFormat:@"%.2f",grade];
        } else {
            self.gradeTextField.text = @"";
        }
        
    } else {
        self.firstNameTextField.text = @"";
        self.lastNameTextField.text = @"";
        self.dateOfBirthTextField.text = @"";
        self.genderSegmentedControl.selectedSegmentIndex = 0;
        self.gradeTextField.text = @"";
        [self setEnableTableView:NO];
    }
}

- (AMStudent*) previousStudent {
    
    if ([self canGoPreviousStudent]) {
        NSInteger index = [self.students indexOfObject:self.currentStudent];
        return [self.students objectAtIndex:index - 1];
    }
    
    return self.currentStudent;
    
}

- (AMStudent*) nextStudent {
    
    if ([self canGoNextStudent]) {
        NSInteger index = [self.students indexOfObject:self.currentStudent];
        return [self.students objectAtIndex:index + 1];
    }
    
    return self.currentStudent;
    
}

- (void) removeCurrentStudent {
    
    if ([self canRemoveStudent]) {
        
        [self removeObserverForCurrentStudent];
        
        NSMutableArray* students = [self mutableArrayValueForKey:@"students"];
        AMStudent* removeStudent = self.currentStudent;
        if ([self canGoNextStudent]){
            self.currentStudent = [self nextStudent];
            [self reloadTableViewContentWithRowAnimation:UITableViewRowAnimationLeft];
        } else if ([self canGoPreviousStudent]) {
            self.currentStudent = [self previousStudent];
            [self reloadTableViewContentWithRowAnimation:UITableViewRowAnimationRight];
        } else {
            
            self.currentStudent = nil;
        }
        [students removeObject:removeStudent];
        [self  addObserverForCurrentStudent];
    }
    
}

- (void) addNewStudent {
    
    if (self.currentStudent) {
        [self removeObserverForCurrentStudent];
    }
    
    NSMutableArray* students = [self mutableArrayValueForKey:@"students"];
    AMStudent* newStudent = [[AMStudent alloc] init];
    self.currentStudent = newStudent;
    [students addObject:newStudent];
    
    [self addObserverForCurrentStudent];
    
}

#pragma mark - AMDatePickerControllerDelegate

- (void) didValueChangedDatePicker:(UIDatePicker*)datePicker {
    
    NSDate* newDate = datePicker.date;
    [self.currentStudent setValue:newDate forKey:@"dateOfBirth"];
    self.dateOfBirthTextField.text = [self.dateFormatter stringFromDate:[self.currentStudent valueForKey:@"dateOfBirth"]];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.dateOfBirthTextField]) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            [self performSegueWithIdentifier:@"AMDatePickerControllerModally" sender:nil];
            
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [self performSegueWithIdentifier:@"AMDatePickerControllerPopover" sender:nil];
            
        }
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if ([textField isEqual:self.firstNameTextField]) {
        
        [self.currentStudent setValue:textField.text forKey:@"firstName"];
        
    } else if ([textField isEqual:self.lastNameTextField]) {
        
        [self.currentStudent setValue:textField.text forKey:@"lastName"];
        
    }
    
    return YES;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.gradeTextField]) {
        
        [textField resignFirstResponder];
        
    } else if ([textField isEqual:self.firstNameTextField]) {

        [self.lastNameTextField becomeFirstResponder];

    } else if ([textField isEqual:self.lastNameTextField]) {
        
        [self.gradeTextField becomeFirstResponder];
        
    }
    
    return YES;
    
}

#pragma mark - Actions

- (void) actionCancelBarButtonItem:(UIBarButtonItem*)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)actionEditingChangedFirstNameTextField:(UITextField *)sender {
    
    [self.currentStudent setValue:sender.text forKey:@"firstName"];
    
}

- (IBAction)actionEditingChangedLastNameTextField:(UITextField *)sender {
    
    [self.currentStudent setValue:sender.text forKey:@"lastName"];
    
}

- (IBAction)actionEditingChangedGradeTextField:(UITextField *)sender {
    
    float grade = [sender.text floatValue];
    
    [self.currentStudent setValue:[NSNumber numberWithFloat:grade] forKey:@"grade"];
    
}

- (IBAction)actionValueChangedGenderSegmentedControl:(UISegmentedControl *)sender {
    
    AMGenderType gender = sender.selectedSegmentIndex;
    
    [self.currentStudent setValue:[NSNumber numberWithInt:gender] forKey:@"gender"];
    
}

- (IBAction)actionPreviousBarButtonItem:(UIBarButtonItem *)sender {

    [self removeObserverForCurrentStudent];
    self.currentStudent = [self previousStudent];
    [self addObserverForCurrentStudent];
    
    [self reloadTableViewContentWithRowAnimation:UITableViewRowAnimationRight];
    [self showCurrentStudent];
    [self updateBarButtonItems];

}

- (IBAction)actionNextBarButtonItem:(UIBarButtonItem *)sender {
    
    [self removeObserverForCurrentStudent];
    self.currentStudent = [self nextStudent];
    [self addObserverForCurrentStudent];
    
    [self reloadTableViewContentWithRowAnimation:UITableViewRowAnimationLeft];
    [self showCurrentStudent];
    [self updateBarButtonItems];
    
}

- (IBAction)actionAddBarButtonItem:(UIBarButtonItem *)sender {
    
    [self setEnableTableView:YES];
    [self addNewStudent];
    [self reloadTableViewContentWithRowAnimation:UITableViewRowAnimationLeft];
    [self showCurrentStudent];
    [self updateBarButtonItems];
    [self.firstNameTextField becomeFirstResponder];
    
}

- (IBAction)actionRemoveBarButtonItem:(UIBarButtonItem *)sender {
    
    [self removeCurrentStudent];
    [self showCurrentStudent];
    [self updateBarButtonItems];
    
}

- (IBAction)actionResetBarButtonItem:(UIBarButtonItem *)sender {
    
    [self.currentStudent resetValueForProperties];
    [self showCurrentStudent];
    
}

- (IBAction)actionInfoBarButtonItem:(UIBarButtonItem *)sender {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    
    NSDate* minDate = [self.students valueForKeyPath:@"@min.dateOfBirth"];
    NSString* message = [NSString stringWithFormat:@"min year of birth - %@", [dateFormatter stringFromDate:minDate]];
    
    NSDate* maxDate = [self.students valueForKeyPath:@"@max.dateOfBirth"];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"\nmax year of birth - %@", [dateFormatter stringFromDate:maxDate]]];
    
    CGFloat sum = [[self.students valueForKeyPath:@"@sum.grade"] floatValue];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"\nsum grade of students - %.2f", sum]];
    
    CGFloat avg = [[self.students valueForKeyPath:@"@avg.grade"] floatValue];
    message = [message stringByAppendingString:[NSString stringWithFormat:@"\naverage grade of students - %.2f", avg]];
    
    [self showAlertWithTitle:@"Info" andWithMessage:message];
    
}

@end
