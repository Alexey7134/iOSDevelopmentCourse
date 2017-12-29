//
//  AMCoursesTableViewController.m
//  41CoreData
//
//  Created by Admin on 13.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMCoursesTableViewController.h"
#import "AMCourse+CoreDataClass.h"
#import "AMDetailCourseTableViewController.h"

@interface AMCoursesTableViewController ()

@end

@implementation AMCoursesTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View lifecycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    
}

#pragma mark - Actions

- (void) actionAdd:(id)sender {
    
    [self performSegueWithIdentifier:@"AMDetailCourseTableViewController" sender:nil];
    
}

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
    [super configureCell:cell withObject:object];
    
    AMCourse* course = (AMCourse*)object;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", course.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"students: %d", (int)[course.students count]];
    
}


#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[AMDetailCourseTableViewController class]]) {
        
        AMDetailCourseTableViewController* detailCourseTableViewController = segue.destinationViewController;
        detailCourseTableViewController.course = sender;
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"AMDetailCourseTableViewController" sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController*)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<AMCourse*> *fetchRequest = AMCourse.fetchRequest;
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController<AMCourse*> *aFetchedResultsController =
                [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                    managedObjectContext:self.managedObjectContext
                                                      sectionNameKeyPath:nil
                                                               cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
    
}

@end
