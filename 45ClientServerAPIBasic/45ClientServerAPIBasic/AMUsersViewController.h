//
//  AMUsersViewController.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 05.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMUsersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;

- (IBAction)actionGroups:(UIBarButtonItem*)sender;
- (IBAction)actionMessages:(UIBarButtonItem*)sender;

@end
