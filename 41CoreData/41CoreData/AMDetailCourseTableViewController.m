//
//  AMDetailCourseTableViewController.m
//  41CoreData
//
//  Created by Admin on 13.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDetailCourseTableViewController.h"
#import "AMDetailStudentTableViewCell.h"
#import "AMDetailStudentTableViewController.h"
#import "AMSelectionTableViewController.h"
#import "AMDataManager.h"
#import "AMCourse+CoreDataClass.h"
#import "AMSubject+CoreDataClass.h"
#import "AMStudent+CoreDataClass.h"

typedef NS_ENUM(NSInteger, AMTypeSelectedValue) {
    AMTypeSelectedValueNone,
    AMTypeSelectedValueSubject,
    AMTypeSelectedValueTeacher,
    AMTypeSelectedValueStudents
};

const NSString* infoSegueKeyRequest = @"infoSegueKeyRequest";
const NSString* infoSegueKeyMultipleSelection = @"infoSegueKeyMultipleSelection";

@interface AMDetailCourseTableViewController () <UITextFieldDelegate, AMSelectionTableViewDelegate>

@property (strong, nonatomic) NSMutableArray* students;
@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) AMSubject* subject;
@property (strong, nonatomic) AMStudent* teacher;
@property (assign, nonatomic) AMTypeSelectedValue selectedValue;

@end

@implementation AMDetailCourseTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem* saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(actionSave:)];
    
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    
    if (self.course) {
        self.navigationItem.title = @"Edit course";
    } else {
        self.navigationItem.title = @"Add course";
    }

    if (self.course) {
        if (self.course.students) {
            self.students = [NSMutableArray arrayWithArray:[self.course.students allObjects]];
        } else {
            self.students = [NSMutableArray array];
        }
        
        self.subject = self.course.subject;
        self.teacher = self.course.teacher;
        
    } else {
        
        self.students = [NSMutableArray array];
        
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.nameTextField becomeFirstResponder];
    self.selectedValue = AMTypeSelectedValueNone;
    
}

#pragma mark - Actions

- (void) actionSave:(UIBarButtonItem*)sender {

    if ([self.nameTextField.text length] == 0) {
        
        return;
        
    }
    
    if (!self.subject) {
        
        return;
        
    }
    
    NSManagedObjectContext* context = [AMDataManager sharedManager].persistentContainer.viewContext;
    
    if (!self.course) {
        
        self.course = [[AMCourse alloc] initWithContext:context];
        
    }
    
    self.course.name = self.nameTextField.text;
    
    self.course.subject = self.subject;
    self.course.teacher = self.teacher;
    self.course.students = [NSSet setWithArray:self.students];
    
    NSError *error = nil;
    if (![context save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[AMDetailStudentTableViewController class]]) {
        
        AMDetailStudentTableViewController* detailStudentTableViewController = segue.destinationViewController;
        detailStudentTableViewController.student = sender;
        return;
        
    }
    
    NSDictionary* infoSegue = (NSDictionary*)sender;
    
    UINavigationController* navigationController = segue.destinationViewController;
    
    AMSelectionTableViewController* selectionTableViewController = [navigationController.viewControllers firstObject];
    
    NSFetchRequest* fetchRequest = [infoSegue objectForKey:infoSegueKeyRequest];
    
    AMSelectionType selectionType = AMSelectionTypeSingle;
    if ([[infoSegue objectForKey:infoSegueKeyMultipleSelection] boolValue]) {
        selectionType = AMSelectionTypeMultiple;
    }
    
    if ([fetchRequest.entityName isEqualToString:@"AMSubject"]) {

        if (self.subject) {
            selectionTableViewController.selectedRows = [NSMutableArray arrayWithObject:self.subject];
        } else {
            selectionTableViewController.selectedRows = [NSMutableArray array];
        }
        
        selectionTableViewController.navigationItem.title = @"Select subject";
        void (^actionAddSubject) (UIViewController*) = ^ (UIViewController* topViewController) {
            
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Add" message:@"New subject:" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* addButton = [UIAlertAction actionWithTitle:@"Add subject" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action){
                                                                  if ([alertController.textFields[0].text length] > 0) {
                                                                      
                                                                      NSManagedObjectContext* context = [AMDataManager sharedManager].persistentContainer.viewContext;
                                                                      AMSubject* subject = [[AMSubject alloc] initWithContext:context];
                                                                      subject.name  = alertController.textFields[0].text;
                                                                      
                                                                      NSError *error = nil;
                                                                      if (![context save:&error]) {
                                                                          NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                                                                          abort();
                                                                          
                                                                      }
                                                                  }
                                                              }];
            
            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:addButton];
            [alertController addAction:cancelButton];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"subject";
                textField.keyboardType = UIKeyboardTypeAlphabet;
                textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                textField.autocorrectionType = UITextAutocorrectionTypeNo;
                textField.returnKeyType = UIReturnKeyDone;
            }];
            
            [topViewController presentViewController:alertController animated:YES completion:nil];
            
        };
        
        selectionTableViewController.actionAddNewRow = actionAddSubject;
        
        
    } else if ([fetchRequest.entityName isEqualToString:@"AMStudent"]) {
        
        if (selectionType == AMSelectionTypeMultiple) {
            selectionTableViewController.selectedRows = self.students;
            selectionTableViewController.navigationItem.title = @"Select students";
        } else {
            if (self.teacher) {
                selectionTableViewController.selectedRows = [NSMutableArray arrayWithObject:self.teacher];
            } else {
                selectionTableViewController.selectedRows = [NSMutableArray array];
            }
            selectionTableViewController.navigationItem.title = @"Select teacher";
            
        }
        selectionTableViewController.actionAddNewRow = nil;
        
    }
    
    selectionTableViewController.selection = selectionType;
    selectionTableViewController.fetchRequest = fetchRequest;
    selectionTableViewController.delegate = self;
    
}

#pragma mark - AMSelectionTableViewDelegate

- (void) didSelectObject:(id)object {
    
    if (self.selectedValue == AMTypeSelectedValueSubject) {
        
        self.subject = object;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    } else if (self.selectedValue == AMTypeSelectedValueStudents) {
        
        
        [self.students addObject:object];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
        
    } else if (self.selectedValue == AMTypeSelectedValueTeacher) {
        
        self.teacher = object;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}

- (void) didDeselectObject:(id)object {
    
    [self.students removeObject:object];
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary* infoSegue = [NSMutableDictionary dictionary];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            self.selectedValue = AMTypeSelectedValueSubject;
            
            NSFetchRequest *fetchRequest = AMSubject.fetchRequest;
            [fetchRequest setFetchBatchSize:20];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [fetchRequest setSortDescriptors:@[sortDescriptor]];
            [infoSegue setObject:fetchRequest forKey:infoSegueKeyRequest];
            [infoSegue setObject:[NSNumber numberWithBool:NO] forKey:infoSegueKeyMultipleSelection];
            
            [self performSegueWithIdentifier:@"AMSelectionTableViewController" sender:infoSegue];
            
        } else if (indexPath.row == 2) {
            
            self.selectedValue = AMTypeSelectedValueTeacher;
            
            NSFetchRequest *fetchRequest = AMStudent.fetchRequest;
            [fetchRequest setFetchBatchSize:20];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
            [fetchRequest setSortDescriptors:@[sortDescriptor]];
            [infoSegue setObject:fetchRequest forKey:infoSegueKeyRequest];
            [infoSegue setObject:[NSNumber numberWithBool:NO] forKey:infoSegueKeyMultipleSelection];
            
            [self performSegueWithIdentifier:@"AMSelectionTableViewController" sender:infoSegue];
            
        }
    } else if (indexPath == [NSIndexPath indexPathForRow:0 inSection:1]) {
        
        self.selectedValue = AMTypeSelectedValueStudents;
        
        NSFetchRequest *fetchRequest = AMStudent.fetchRequest;
        [fetchRequest setFetchBatchSize:20];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        [infoSegue setObject:fetchRequest forKey:infoSegueKeyRequest];
        [infoSegue setObject:[NSNumber numberWithBool:YES] forKey:infoSegueKeyMultipleSelection];
        
        [self performSegueWithIdentifier:@"AMSelectionTableViewController" sender:infoSegue];
        
    } else if (indexPath.section == 1 && indexPath.row > 0) {
        
        AMStudent* student = [self.students objectAtIndex:indexPath.row - 1];
        [self performSegueWithIdentifier:@"AMInfoStudentTableViewController" sender:student];
        
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        return YES;
    }
    return NO;
    
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Remove" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.students removeObjectAtIndex:indexPath.row - 1];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
        
    }];
    
    removeAction.backgroundColor = [UIColor colorWithRed:126/256.f green:61/256.f blue:74/256.f alpha:1.f];
    
    return @[removeAction];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 3;
        
    } else {
        
        return [self.students count] + 1;
        
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            AMDetailStudentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMDetailCourseNameTableViewCell" forIndexPath:indexPath];
            cell.title.text = @"Name";
            cell.textField.placeholder = @"name";
            cell.formatTextField = AMFormatTextFieldName;
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.course.name;
            self.nameTextField = cell.textField;
            
            return cell;
            
        } else {
            
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMDetailCourseTableViewCell" forIndexPath:indexPath];
            
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Subject";
                if (self.subject == nil) {
                    cell.detailTextLabel.text = @"Select subject";
                } else {
                    cell.detailTextLabel.text = self.subject.name;
                }
            } else {
                
                cell.textLabel.text = @"Teacher";
                
                if (self.teacher== nil) {
                    cell.detailTextLabel.text = @"Select teacher";
                } else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.teacher.lastName, self.teacher.firstName];
                }
                
            }
            
            return cell;
        }
        
    } else {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AMDetailStudentsTableViewCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"Add student";
            cell.textLabel.textColor = [UIColor colorWithRed:126/256.f green:61/256.f blue:74/256.f alpha:1.f];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        } else {
            
            if (self.students) {
                
                AMStudent* student = [self.students objectAtIndex:indexPath.row - 1];
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                
            }
        }
        return  cell;
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Course Info";
    } else {
        return @"Course students";
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString* newString = [NSMutableString stringWithString:textField.text];
    [newString replaceCharactersInRange:range withString:string];
    
    NSMutableCharacterSet* validCharacterName = [NSMutableCharacterSet letterCharacterSet];
    [validCharacterName formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [validCharacterName formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"+ "]];
    
    NSArray* componentsString = [newString componentsSeparatedByCharactersInSet:[validCharacterName invertedSet]];
    
    if ([componentsString count] > 1) {
        return NO;
    }
  
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
