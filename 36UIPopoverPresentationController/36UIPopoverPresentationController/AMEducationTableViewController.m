//
//  AMEducationTableViewController.m
//  36UIPopoverPresentationController
//
//  Created by Admin on 22.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMEducationTableViewController.h"

@implementation AMEducationTableViewController

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.indexSelectedRow = indexPath.row;
    [self.tableView reloadData];
    [self.delegate didSelectRowAtIndex:indexPath.row];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.dataSource count] > 0) {
        return [self.dataSource count];
    } else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"AMEducationTableViewCell"];
    
    if (indexPath.row == self.indexSelectedRow) {
        cell.imageView.image = [UIImage imageNamed:@"CheckBoxSelected.png"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"CheckBox.png"];
    }
    
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
    
}

@end
