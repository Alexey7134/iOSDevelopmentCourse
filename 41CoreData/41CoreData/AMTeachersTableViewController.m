//
//  AMTeachersTableViewController.m
//  41CoreData
//
//  Created by Admin on 17.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMTeachersTableViewController.h"
#import "AMStudent+CoreDataClass.h"
#import "AMCourse+CoreDataClass.h"
#import "AMSubject+CoreDataClass.h"
#import "AMDetailStudentTableViewController.h"

@interface AMTeachersTableViewController ()

@property (strong, nonatomic) NSMutableArray* subjects;
@property (strong, nonatomic) NSMutableDictionary* courses;
@property (strong, nonatomic) NSMutableArray* teachers;

@end

@implementation AMTeachersTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.subjects = [NSMutableArray array];
    self.courses = [NSMutableDictionary dictionary];
    self.teachers = [NSMutableArray array];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self updateSubjects];
    [self updateCourses];
    [self updateTeachers];
    [self.tableView reloadData];
    
}

#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[AMDetailStudentTableViewController class]]) {
        
        AMDetailStudentTableViewController* detailStudentTableViewController = segue.destinationViewController;
        detailStudentTableViewController.student = sender;
        return;
        
    }
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMStudent* teacher = [[self.teachers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"AMInfoTeacherTableViewController" sender:teacher];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.teachers objectAtIndex:section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    id object = [[self.teachers objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    [self configureCell:cell withObject:object];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.subjects count];
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.subjects objectAtIndex:section] name];
    
}

#pragma mark - Methods

- (void) updateSubjects {
    
    [self.subjects removeAllObjects];
    
    NSFetchRequest<AMSubject*> *fetchRequest = AMSubject.fetchRequest;
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    fetchRequest.propertiesToFetch = @[@"name"];
    fetchRequest.returnsDistinctResults = YES;
    
    NSError *error;
    NSArray *subjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSDictionary* anySubject in subjects) {
        
        [self.subjects addObject:anySubject];
        
    }
    
}

- (void) updateCourses {
    
    [self.courses removeAllObjects];
    
    for (AMSubject* anySubject in self.subjects) {
        
        NSFetchRequest<AMCourse*> *fetchRequest = AMCourse.fetchRequest;
        
        [fetchRequest setFetchBatchSize:20];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];

        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"subject = %@", anySubject];
        fetchRequest.predicate = predicate;
        
        NSError *error;
        
        NSArray *courses = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
        [self.courses setObject:courses forKey:anySubject.name];
        
    }
    
}

- (void) updateTeachers {
    
    [self.teachers removeAllObjects];
    
    NSFetchRequest<AMStudent*> *fetchRequest = AMStudent.fetchRequest;
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *teachers = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (AMSubject* anySubject in self.subjects) {
        
        NSArray* courses = [self.courses objectForKey:anySubject.name];
        
        NSMutableArray* array = [NSMutableArray array];
        
        for (AMStudent* anyTeacher in teachers) {
            
            NSSet* teachingCourses = anyTeacher.teacher;
            
            for (AMCourse* anyCourse in courses) {
                if ([teachingCourses containsObject:anyCourse]) {
                    [array addObject:anyTeacher];
                    break;
                }
            }
        }
        
        [self.teachers addObject:array];
        
    }
    
}

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {

    AMStudent* teacher = object;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.lastName, teacher.firstName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"courses: %d", (int)[teacher.teacher count]];
    
}

@end
