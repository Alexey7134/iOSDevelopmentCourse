//
//  AMGenerateDataOperation.m
//  35UITableViewSearch
//
//  Created by Admin on 18.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMGenerateDataOperation.h"

NSString *kStudents = @"kStudents";
NSString *kDataSet = @"kDataSet";
NSString *kGenerateDataSetDidFinish = @"kGenerateDataSetDidFinish";

@interface AMGenerateDataOperation ()

@property (strong, nonatomic) NSMutableArray* dataSet;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;

@end

@implementation AMGenerateDataOperation

- (instancetype)initWithStudents:(NSArray*)students withFilter:(NSString*)filter usingSortingMode:(AMSortingMode)sortingMode isNeedsSorting:(BOOL)needsSorting {
    self = [super init];
    if (self) {
        self.students = [NSArray arrayWithArray:students];
        self.sortingMode = sortingMode;
        self.filter = filter;
        self.isNeedsSorting = needsSorting;
        self.dateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

- (void) main {
    
    if (!self.isCancelled) {
        
        //-----------sorting data
        
        if (self.isNeedsSorting) {
            
            NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
            NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
            NSSortDescriptor* dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfBirth" ascending:YES comparator:^NSComparisonResult(NSDate* obj1, NSDate* obj2) {
                [self.dateFormatter setDateFormat:@"MM"];
                NSString* month1 = [self.dateFormatter stringFromDate:obj1];
                NSString* month2 = [self.dateFormatter stringFromDate:obj2];
                return [month1 compare:month2];
            }];
            NSArray* descriptors;
            switch (self.sortingMode) {
                case 0:
                    descriptors = [NSArray arrayWithObjects:dateDescriptor, firstNameDescriptor, lastNameDescriptor, nil];
                    break;
                case 1:
                    descriptors = [NSArray arrayWithObjects:firstNameDescriptor, lastNameDescriptor, dateDescriptor, nil];
                    break;
                case 2:
                    descriptors = [NSArray arrayWithObjects:lastNameDescriptor, dateDescriptor, firstNameDescriptor, nil];
                    break;
            }
            
            if (!self.isCancelled) {
            
                self.students = [self.students sortedArrayUsingDescriptors:descriptors];
                
            }
            
        }
        
        //---------generate new data set
        
        if (!self.isCancelled) {
            
            NSString* currentName = @"";
            NSMutableArray* studentsSet;
            self.dataSet = [NSMutableArray array];
            
            for (AMStudent* student in self.students) {

                if (!self.isCancelled) {
                    NSString* shortName = nil;
                    switch (self.sortingMode) {
                        case 0:
                            [self.dateFormatter setDateFormat:@"MM"];
                            shortName = [self.dateFormatter stringFromDate:student.dateOfBirth];
                            break;
                        case 1:
                            shortName = [student.firstName substringToIndex:1];
                            break;
                        case 2:
                            shortName = [student.lastName substringToIndex:1];
                            break;
                    }
                    
                    if ([self.filter length] > 0 && [[[NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName] lowercaseString] rangeOfString:[self.filter lowercaseString]].location == NSNotFound ) {
                        continue;
                    }
                    
                    if (![shortName isEqualToString:currentName]) {
                        studentsSet = [NSMutableArray array];
                        AMDataSet* newDataSet = [[AMDataSet alloc] init];
                        [self.dateFormatter setDateFormat:@"MMMM"];
                        newDataSet.shortSetName = shortName;
                        if (self.sortingMode == 0) {
                            newDataSet.setName = [self.dateFormatter stringFromDate:student.dateOfBirth];
                        } else {
                            newDataSet.setName = shortName;
                        }
                        
                        
                        newDataSet.dataSet = studentsSet;
                        [self.dataSet addObject:newDataSet];
                        currentName = shortName;
                    }
                    
                    [studentsSet addObject:student];
                    
                }
                
            }
          
        }
        if (!self.isCancelled) {
            //-------send notification is finished
            NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:self.dataSet, kDataSet, self.students, kStudents, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kGenerateDataSetDidFinish object:nil userInfo:info];
            NSLog(@"GenerateDataSetDidFinish");
            
        } else {
            NSLog(@"CANCELLEDDDDDDDDD");
        }

        
    }
    
}

@end
