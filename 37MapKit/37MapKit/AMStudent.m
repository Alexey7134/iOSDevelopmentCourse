//
//  AMStudent.m
//  35UITableViewSearch
//
//  Created by Admin on 17.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudent.h"

static NSInteger countFirstNameMan = 20;
static NSInteger countFirstNameWoman = 20;
static NSInteger countLastName = 20;

static NSString* firstNamesMan[] = {@"Max", @"Alex", @"Nikita", @"Ivan", @"Sergey", @"Denis", @"Pavel",
                                    @"Itan", @"Vladimir", @"Alexey", @"Dmitriy", @"Anton", @"Andrey",
                                    @"Petr", @"Fedor", @"Arseniy", @"Elisey", @"Konstantin", @"Nikolay", @"Iosif"};

static NSString* firstNamesWoman[] = {@"Anna", @"Mia", @"Natalia", @"Irina", @"Sofia",
                                        @"Karil", @"Nikki", @"Marina", @"Victoria", @"Larisa",
                                        @"Alevtina", @"Maria", @"Tamara", @"Svetlana", @"Uliya",
                                        @"Alena", @"Vasilisa", @"Vasilina", @"Darya", @"Margarita"};

static NSString* lastNames[] = {@"Loginok", @"Potapovik", @"Sidorovchik", @"Alekseevich",
                                @"Shikinovich", @"Shagonovich", @"Rusetsk", @"Akimovich",
                                @"Kniga", @"Drozd", @"Lis", @"Volk", @"Miksiuk", @"Shikinchuk",
                                @"Surdiuk", @"Pinchuk", @"Shelest", @"Kol", @"Akulich", @"Wolf"};

@implementation AMStudent

+ (AMStudent*) randomStudent  {
    
    AMStudent* student = [[AMStudent alloc] init];
    
    student.gender = (AMGenderType)(arc4random() % 200) / 100;
    
    if (student.gender == AMGenderTypeMan) {
        student.firstName = firstNamesMan[arc4random() % (countFirstNameMan * 10) / 10];
    } else {
        student.firstName = firstNamesWoman[arc4random() % (countFirstNameWoman * 10) / 10];
    }
    
    student.lastName = lastNames[arc4random() % (countLastName * 10) / 10];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:arc4random() % (365 * 24 * 60 * 60)];
    NSDateComponents* dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    dateComponents.year = dateComponents.year - ((arc4random() % 100) / 10 + 18);
    student.dateOfBirth = [calendar dateFromComponents:dateComponents];
    
    student.title = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    student.subtitle = [dateFormatter stringFromDate:student.dateOfBirth];
    
    return student;
    
}

- (NSString *)description {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    return [NSString stringWithFormat:@"%@ %@, date of birth - %@, latitude - %.4f, longitude - %.4f",
                                        self.lastName, self.firstName,
                                        [dateFormatter stringFromDate:self.dateOfBirth],
                                        self.coordinate.latitude, self.coordinate.longitude];
    
}

@end
