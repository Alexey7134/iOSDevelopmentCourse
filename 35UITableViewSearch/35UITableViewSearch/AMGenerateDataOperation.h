//
//  AMGenerateDataOperation.h
//  35UITableViewSearch
//
//  Created by Admin on 18.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMStudent.h"
#import "AMDataSet.h"

extern NSString *kStudents;
extern NSString *kDataSet;
extern NSString *kGenerateDataSetDidFinish;

typedef NS_ENUM(NSInteger, AMSortingMode) {
    AMSortingModeDate = 0,
    AMSortingModeFirstName = 1,
    AMSortingModeLastName = 2
};

@interface AMGenerateDataOperation : NSOperation

@property (strong, nonatomic) NSArray* students;
@property (assign, nonatomic) AMSortingMode sortingMode;
@property (strong, nonatomic) NSString* filter;
@property (assign, nonatomic) BOOL isNeedsSorting;

- (instancetype)initWithStudents:(NSArray*)students withFilter:(NSString*)filter usingSortingMode:(AMSortingMode)sortingMode isNeedsSorting:(BOOL)needsSorting;

@end
