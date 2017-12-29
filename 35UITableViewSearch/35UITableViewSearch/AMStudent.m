//
//  AMStudent.m
//  35UITableViewSearch
//
//  Created by Admin on 17.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudent.h"

static NSString* firstNames[] = {@"Anna", @"Max", @"Alex",@"Mia", @"Natalia",
                                @"Nikita", @"Ivan", @"Sergey", @"Denis", @"Pavel",
                                @"Irina", @"Sofia", @"Karil", @"Nikki", @"Itan", @"Vladimir"};

static NSString* lastNames[] = {@"Loginov", @"Potapov", @"Sidorov", @"Alekseev",
                                @"Shikin", @"Shapkin", @"Rusetskiy", @"Akimov",
                                @"Kniga", @"Drozd", @"Lis", @"Volk", @"Miksiuk",
                                @"Surdiuk", @"Pinchuk", @"Shelest", @"Kol", @"Akulich", @"Wolf"};

@implementation AMStudent

+ (AMStudent*) randomStudent  {
    
    AMStudent* student = [[AMStudent alloc] init];
    student.firstName = firstNames[arc4random() % 160 / 10];
    student.lastName = lastNames[arc4random() % 190 / 10];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:arc4random() % (365 * 24 * 60 * 60)];
    NSDateComponents* dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    dateComponents.year = dateComponents.year - ((arc4random() % 100) / 10 + 18);
    student.dateOfBirth = [calendar dateFromComponents:dateComponents];
    
    return student;
    
}

@end
