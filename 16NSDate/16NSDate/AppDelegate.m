//
//  AppDelegate.m
//  16NSDate
//
//  Created by Admin on 06.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AppDelegate.h"
#import "AMStudent.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSTimer* timerDay;
@property (strong, nonatomic) NSMutableArray* students;
@property (strong, nonatomic) NSDate* currentDate;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd.MM.YYYY"];

    self.currentDate = [NSDate date];
    
    self.students = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 30; i++) {
        AMStudent* student = [[AMStudent alloc] init];
        [self.students addObject:student];
    }
    
    [self.students sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        AMStudent* student1 = obj1;
        AMStudent* student2 = obj2;
        return [student2.dateOfBirth compare:student1.dateOfBirth];
    }];
    
    
    for (AMStudent* student in self.students) {
        NSLog(@"%@ %@, date of birth - %@", student.firstName, student.lastName, [self.dateFormatter stringFromDate:student.dateOfBirth]);
    }
    
    self.timerDay = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(happyBirthDay:) userInfo:0 repeats:YES];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    AMStudent* youngestStudent = [self.students firstObject];
    AMStudent* oldestStudent = [self.students lastObject];
    NSDateComponents* differentsDate = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:oldestStudent.dateOfBirth toDate:youngestStudent.dateOfBirth options:0];
    NSLog(@"Biggest age differents: year - %d, mount - %d, week - %d, day - %d",differentsDate.year, differentsDate.month, differentsDate.day / 7, differentsDate.day % 7);
    
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 2017;
    dateComponents.day = 1;
    dateComponents.month = 1;
    for (NSInteger i = 0; i < 12; i++) {
        NSDate* currentDate = [calendar dateFromComponents:dateComponents];
        dateComponents.month++;
        NSLog(@"date - %@ day week - %@", [self.dateFormatter stringFromDate:currentDate], [calendar.weekdaySymbols objectAtIndex:[calendar components:NSCalendarUnitWeekday fromDate:currentDate].weekday - 1]);
    }

    NSDateComponents* dateComponentsSunday = [[NSDateComponents alloc] init];
    dateComponentsSunday.year = 2017;
    dateComponentsSunday.weekday = 1;
    dateComponentsSunday.weekdayOrdinal = 1;
    while (YES) {
        NSDate* currentDate = [calendar dateFromComponents:dateComponentsSunday];
        if ([calendar components:NSCalendarUnitYear fromDate:currentDate].year != 2017) {
            break;
        }
        NSLog(@"%@",[self.dateFormatter stringFromDate:currentDate]);
        dateComponentsSunday.weekdayOrdinal++;
    }
    
    NSDateComponents* dateComponentsWorkDay = [[NSDateComponents alloc] init];
    dateComponentsWorkDay.year = 2017;
    dateComponentsWorkDay.month = 1;
    dateComponentsWorkDay.day = 1;
    NSInteger currentMonth = 1;
    NSInteger countWorkDay = 0;

    while (YES) {
        dateComponentsWorkDay.day++;
        NSDate* currentDate = [calendar dateFromComponents:dateComponentsWorkDay];

        if ([calendar components:NSCalendarUnitMonth | NSCalendarUnitTimeZone fromDate:currentDate].month >  currentMonth) {
            NSLog(@"Workday in %@ 2017: %d", [calendar.monthSymbols objectAtIndex:currentMonth - 1], countWorkDay);
            countWorkDay = 0;
            currentMonth++;
        }
        if ([calendar components:NSCalendarUnitMonth | NSCalendarUnitTimeZone fromDate:currentDate].month == 1 && currentMonth == 12) {
            NSLog(@"Workday in %@ 2017: %d", [calendar.monthSymbols objectAtIndex:currentMonth - 1], countWorkDay);
            break;
        }
        if ([calendar components:NSCalendarUnitWeekday fromDate:currentDate].weekday > 1 && [calendar components:NSCalendarUnitWeekday fromDate:currentDate].weekday < 7) {
            countWorkDay++;
        }
    }
  
    return YES;
}

- (void) happyBirthDay:(NSTimer*)timer {
    
    self.currentDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.currentDate];
    NSMutableArray* happyStudents = [[NSMutableArray alloc] init];
    for (AMStudent* student in self.students) {
        if ([self isBirthDay:student day:self.currentDate]) {
            [happyStudents addObject:student];
        }
    }
    if ([happyStudents count] > 0) {
        NSLog(@"-----Bitrhday %@ in next students:-----", [self.dateFormatter stringFromDate:self.currentDate]);
        for (AMStudent* student in happyStudents) {
            NSLog(@"%@ %@, date of birth - %@", student.firstName, student.lastName, [self.dateFormatter stringFromDate:student.dateOfBirth]);
        }
    }

}

- (BOOL) isBirthDay:(AMStudent*)student day:(NSDate*) date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* componentsStudent = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:student.dateOfBirth];
    NSDateComponents* componentsDate = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:date];
    if ((componentsStudent.day == componentsDate.day) && (componentsStudent.month == componentsDate.month)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
