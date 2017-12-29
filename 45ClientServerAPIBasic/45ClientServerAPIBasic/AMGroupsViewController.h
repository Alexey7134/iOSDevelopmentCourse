//
//  AMGroupsViewController.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 19.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMGroupsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;

- (IBAction)actionMessages:(UIBarButtonItem*)sender;

@property (assign, nonatomic) long userID;

@end
