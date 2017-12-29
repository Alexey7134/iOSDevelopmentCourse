//
//  AMUserDetailTableViewController.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 04.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMUser;

@interface AMUserDetailTableViewController : UITableViewController

@property (strong, nonatomic) AMUser* user;

@property (weak, nonatomic) IBOutlet UIImageView* photoImageView;
@property (weak, nonatomic) IBOutlet UILabel* ageLabel;
@property (weak, nonatomic) IBOutlet UILabel* countryLabel;
@property (weak, nonatomic) IBOutlet UILabel* cityLabel;


@end
