//
//  AMEducationTableViewController.m
//  36UIPopoverPresentationController
//
//  Created by Admin on 22.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMSelectionTableViewController.h"
#import "AMStudent+CoreDataClass.h"
#import "AMSubject+CoreDataClass.h"

@implementation AMSelectionTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem* doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    self.navigationItem.leftBarButtonItem = doneBarButtonItem;
    
    if (self.actionAddNewRow != nil) {
        UIBarButtonItem* addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
        self.navigationItem.rightBarButtonItem = addBarButtonItem;
    }
    
}

- (void) setSelectedRows:(NSMutableArray *)selectedRows {
    
    _selectedRows = [NSMutableArray arrayWithArray:selectedRows];
    
}

#pragma mark - Actions

- (void) actionDone:(UIBarButtonItem*)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) actionAdd:(UIBarButtonItem*)sender {
    
    if (self.actionAddNewRow != nil) {
        
        self.actionAddNewRow(self);
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.tableView reloadData];
    
    if (self.selection == AMSelectionTypeSingle) {
        
        [self.delegate didSelectObject:object];
        self.selectedRows = [NSMutableArray arrayWithObject:object];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (self.selection == AMSelectionTypeMultiple) {
        
        if ([self.selectedRows containsObject:object]) {
            
            [self.delegate didDeselectObject:object];
            
            [self.selectedRows removeObject:object];
            
        } else {
            
            [self.delegate didSelectObject:object];
            [self.selectedRows addObject:object];
            
        }
    }
    
}

#pragma mark - UITableViewDataSource

- (void) configureCell:(UITableViewCell *)cell withObject:(id)object {

    if ([self.selectedRows containsObject:object]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([object isKindOfClass:[AMStudent class]]) {
        
        AMStudent* student = (AMStudent*)object;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
        
    } else if ([object isKindOfClass:[AMSubject class]]) {
        
        AMSubject* subject = (AMSubject*)object;
        cell.textLabel.text = subject.name;
        
    }

}

#pragma mark - Fetched results controller

- (NSFetchedResultsController*)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = self.fetchRequest;
    
    NSFetchedResultsController* aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
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
