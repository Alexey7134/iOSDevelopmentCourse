//
//  AMUserSubscriptionsViewController.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 07.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AMRequestType) {
    AMRequestTypeSubscription = 0,
    AMRequestTypeFollowers = 1
};

@interface AMUserSubscriptionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (assign, nonatomic) long userID;
@property (assign, nonatomic) AMRequestType requestType;

@end
