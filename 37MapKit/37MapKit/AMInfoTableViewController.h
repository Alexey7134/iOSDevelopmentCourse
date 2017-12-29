//
//  AMInfoTableViewController.h
//  37MapKit
//
//  Created by Admin on 29.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMStudent;

@interface AMInfoTableViewController : UITableViewController

@property (strong, nonatomic) AMStudent* student;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
