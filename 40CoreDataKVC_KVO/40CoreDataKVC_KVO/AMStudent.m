//
//  AMStudent.m
//  40CoreDataKVC_KVO
//
//  Created by Admin on 02.11.17.
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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.firstName = @"";
        self.lastName = @"";
        self.dateOfBirth = [NSDate dateWithTimeIntervalSinceNow:0];
        self.gender = AMGenderTypeMan;
        self.grade = 0;
    }
    return self;
}

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
    
    student.grade = (float)((arc4random() % 30) + 20) / 10.f;
    
    return student;
    
}

- (void) resetValueForProperties {
    
    [self willChangeValueForKey:@"firstName"];
    _firstName = @"";
    [self didChangeValueForKey:@"firstName"];
    
    
    [self willChangeValueForKey:@"lastName"];
    _lastName = @"";
    [self didChangeValueForKey:@"lastName"];
    
    
    [self willChangeValueForKey:@"dateOfBirth"];
    _dateOfBirth = [NSDate dateWithTimeIntervalSinceNow:0];
    [self didChangeValueForKey:@"dateOfBirth"];
    
    
    [self willChangeValueForKey:@"gender"];
    _gender = AMGenderTypeMan;
    [self didChangeValueForKey:@"gender"];
    
    
    [self willChangeValueForKey:@"grade"];
    _grade = 0;
    [self didChangeValueForKey:@"grade"];
    
}

- (NSString *)description {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    return [NSString stringWithFormat:@"%@ %@, date of birth - %@, gender - %d, grade - %f",
            self.lastName, self.firstName,
            [dateFormatter stringFromDate:self.dateOfBirth],
            self.gender, self.grade];
    
}

@end
