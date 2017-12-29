//
//  ViewController.m
//  35UITableViewSearch
//
//  Created by Admin on 17.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "ViewController.h"
#import "AMGenerateDataOperation.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray* students;
@property (strong, nonatomic) NSMutableArray* dataSet;
@property (assign, nonatomic) AMSortingMode sortingMode;

@property (strong, nonatomic) NSOperationQueue* operationQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    
    self.students = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 100000; i++) {
        [self.students addObject:[AMStudent randomStudent]];
    }
    
    self.sortingMode = AMSortingModeDate;
    
    self.dataSet = [NSMutableArray array];
 
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(generateDataSetDidFinish:)
                                                 name:kGenerateDataSetDidFinish
                                               object:nil];
    
    [self generateDataSetInBackgroundWithFilter:@"" needsSorting:YES];
   
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Methods

- (void) generateDataSetDidFinish:(NSNotification *)notification {
    
    NSDictionary* info = notification.userInfo;
    
    self.dataSet = [info objectForKey:kDataSet];
    self.students = [info objectForKey:kStudents];
    __weak ViewController* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
    
}

- (void) generateDataSetInBackgroundWithFilter:(NSString*)filter needsSorting:(BOOL)needsSorting {
    
    __weak ViewController* weakSelf = self;

    [self.operationQueue cancelAllOperations];
    
    AMGenerateDataOperation* generateOperation = [[AMGenerateDataOperation alloc] initWithStudents:weakSelf.students withFilter:filter usingSortingMode:weakSelf.sortingMode isNeedsSorting:needsSorting];
    
    [self.operationQueue addOperation:generateOperation];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    AMDataSet* dataSet = [self.dataSet objectAtIndex:section];
    return [dataSet.dataSet count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMDataSet* dataSet = [self.dataSet objectAtIndex:indexPath.section];
    
    AMStudent* student = [dataSet.dataSet objectAtIndex:indexPath.row];
    
    static NSString* identifierCell = @"identifierCell";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifierCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierCell];
    }
    
    cell.textLabel.text =  [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:student.dateOfBirth];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.dataSet count];
    
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray* titles = [NSMutableArray array];
    
    for (AMDataSet* set in self.dataSet) {
        [titles addObject:set.shortSetName];
    }
    
    return titles;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    AMDataSet* dataSet = [self.dataSet objectAtIndex:section];
    return dataSet.setName;
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    [self generateDataSetInBackgroundWithFilter:searchText needsSorting:NO];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

    [searchBar setShowsCancelButton:YES animated:YES];
    
}

#pragma mark - Actions

- (IBAction)actionValueChangedSortSegmentedControl:(UISegmentedControl *)sender {
    
    self.sortingMode = sender.selectedSegmentIndex;
    [self generateDataSetInBackgroundWithFilter:self.searchBar.text needsSorting:YES];
    
}
@end
