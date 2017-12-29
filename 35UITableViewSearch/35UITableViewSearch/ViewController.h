//
//  ViewController.h
//  35UITableViewSearch
//
//  Created by Admin on 17.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl* sortSegmentedControl;

- (IBAction)actionValueChangedSortSegmentedControl:(UISegmentedControl *)sender;


@end

