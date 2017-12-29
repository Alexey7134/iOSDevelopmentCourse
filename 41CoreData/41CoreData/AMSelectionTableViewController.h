//
//  AMEducationTableViewController.h
//  36UIPopoverPresentationController
//
//  Created by Admin on 22.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFetchingTableViewController.h"

@protocol AMSelectionTableViewDelegate;

typedef NS_ENUM(NSInteger, AMSelectionType) {
    AMSelectionTypeSingle,
    AMSelectionTypeMultiple
};

typedef void (^ActionAddBlock) (UIViewController*);

@interface AMSelectionTableViewController : AMFetchingTableViewController

@property (assign, nonatomic) AMSelectionType selection;
@property (strong, nonatomic) NSFetchRequest* fetchRequest;
@property (strong, nonatomic) NSMutableArray* selectedRows;
@property (copy, nonatomic) ActionAddBlock actionAddNewRow;

@property (weak,nonatomic) id <AMSelectionTableViewDelegate> delegate;

@end

@protocol AMSelectionTableViewDelegate <NSObject>

@optional

- (void) didSelectObject:(id)object;
- (void) didDeselectObject:(id)object;

@end
