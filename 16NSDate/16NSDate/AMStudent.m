//
//  AMStudent.m
//  16NSDate
//
//  Created by Admin on 06.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudent.h"

@implementation AMStudent

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSArray* arrayFirstName = [NSArray arrayWithObjects:@"Anna", @"Karil", @"Max", @"Nikki",
                                                            @"Itan", @"Vladimir", @"Alex", @"Sergey",
                                                            @"Pavel", @"Irina", nil];
        NSArray* arrayLastName = [NSArray arrayWithObjects:@"Miksiuk", @"Surdiuk", @"Pinchuk", @"Shelest",
                                                            @"Kol", @"Drozd", @"Kniga", @"Akulich",
                                                            @"Wolf", @"Lis", nil];
        self.firstName = [arrayFirstName objectAtIndex:arc4random() % 10];
        self.lastName = [arrayLastName objectAtIndex:arc4random() % 10];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:arc4random() % (180 * 24 * 60 * 60)];
        NSDateComponents* dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        dateComponents.year = dateComponents.year - (arc4random() % 35 + 16);
        self.dateOfBirth = [calendar dateFromComponents:dateComponents];
        
    }
    return self;
}


@end
