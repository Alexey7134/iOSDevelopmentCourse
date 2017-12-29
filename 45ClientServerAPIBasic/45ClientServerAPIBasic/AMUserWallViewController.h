//
//  AMUserWallViewController.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 08.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMUserWallViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (assign, nonatomic) long userID;

@end
