//
//  AMDirectoryTableViewController.h
//  34UITableViewNavigationStoryboard
//
//  Created by Admin on 16.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDirectoryTableViewController : UITableViewController

@property (strong, nonatomic) NSString* path;
- (IBAction)actionAddBarButton:(UIBarButtonItem *)sender;
- (IBAction)actionTouchUpInsideInfoButton:(UIButton *)sender;

@end
