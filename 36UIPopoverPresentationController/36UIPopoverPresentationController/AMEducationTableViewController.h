//
//  AMEducationTableViewController.h
//  36UIPopoverPresentationController
//
//  Created by Admin on 22.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMEducationTableViewDelegate;

@interface AMEducationTableViewController : UITableViewController

@property (assign, nonatomic) NSInteger indexSelectedRow;
@property (strong, nonatomic) NSArray* dataSource;

@property (weak,nonatomic) id <AMEducationTableViewDelegate> delegate;

@end

@protocol AMEducationTableViewDelegate <NSObject>

@optional

- (void) didSelectRowAtIndex:(NSInteger)index;

@end