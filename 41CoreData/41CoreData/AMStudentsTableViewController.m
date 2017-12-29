//
//  AMStudentsTableViewController.m
//  41CoreData
//
//  Created by Admin on 10.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudentsTableViewController.h"
#import "AMDataManager.h"
#import "AMDetailStudentTableViewController.h"

@interface AMStudentsTableViewController ()

@end

@implementation AMStudentsTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View lifecycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    
}

#pragma mark - Actions

- (void) actionAdd:(id)sender {
    
    [self performSegueWithIdentifier:@"AMDetailStudentTableViewController" sender:nil];

}

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
    [super configureCell:cell withObject:object];
    
    AMStudent* student = (AMStudent*)object;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"courses: %d", (int)[student.courses count]];
    
}


#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[AMDetailStudentTableViewController class]]) {
        
        AMDetailStudentTableViewController* detailStudentTableViewController = segue.destinationViewController;
        detailStudentTableViewController.student = sender;
        
    }

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"AMDetailStudentTableViewController" sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController*)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<AMStudent*> *fetchRequest = AMStudent.fetchRequest;
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController<AMStudent*> *aFetchedResultsController =
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
