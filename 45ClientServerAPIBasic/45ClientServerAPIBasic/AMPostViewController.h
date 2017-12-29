//
//  AMPostViewController.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 24.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMPostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (assign, nonatomic) long ownerID;
@property (assign, nonatomic) long postID;

@end
