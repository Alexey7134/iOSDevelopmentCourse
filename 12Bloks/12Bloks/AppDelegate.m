//
//  AppDelegate.m
//  12Bloks
//
//  Created by Admin on 29.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AppDelegate.h"
#import "AMStudent.h"
#import "AMPatient.h"

typedef void (^MyBlock) (void);

@interface AppDelegate ()

@property (strong, nonatomic) NSArray* patients;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*
    __block NSInteger count = 0;
    
    void (^testBlock1)(void);
    testBlock1 = ^{
        NSLog(@"Test block number %d", ++count);
    };
    testBlock1();
    
    void (^testBlock2)(NSString*,NSInteger);
    
    testBlock2 = ^(NSString* string,NSInteger intValue) {
        NSLog(@"%@ - %d",string,intValue);
    };
    testBlock2(@"Happy number",13);
    
    BOOL (^testBlockParityOfNumber)(NSInteger) = ^(NSInteger intValue) {
        if (intValue % 2) {
            return NO;
        } else {
            return YES;
        }
    };
    
    BOOL resultTestBlock3 = testBlockParityOfNumber(13);
    NSLog(@"result - %@",resultTestBlock3 ? @"Yes" : @"No");
    
    [self testExecuteBlock:testBlock1];
    [self testExecuteBlock:testBlock1];
    [self testExecuteBlock:testBlock1];
    */
    /*
    AMStudent* student1 = [[AMStudent alloc] initWithName:@"Piter" lastName:@"Ivanov"];
    AMStudent* student2 = [[AMStudent alloc] initWithName:@"Andrew" lastName:@"Petrov"];
    AMStudent* student3 = [[AMStudent alloc] initWithName:@"Nikolay" lastName:@"Sidorov"];
    AMStudent* student4 = [[AMStudent alloc] initWithName:@"Marina" lastName:@"Ivanova"];
    AMStudent* student5 = [[AMStudent alloc] initWithName:@"Alex" lastName:@"Wolf"];
    AMStudent* student6 = [[AMStudent alloc] initWithName:@"Norman" lastName:@"Pig"];
    AMStudent* student7 = [[AMStudent alloc] initWithName:@"Alan" lastName:@"Sidorov"];
    AMStudent* student8 = [[AMStudent alloc] initWithName:@"Anna" lastName:@"Miksiuk"];
    AMStudent* student9 = [[AMStudent alloc] initWithName:@"Alexa" lastName:@"Sorokina"];
    AMStudent* student10 = [[AMStudent alloc] initWithName:@"Karolina" lastName:@"Loeva"];
    AMStudent* student11 = [[AMStudent alloc] initWithName:@"Alex" lastName:@"Ivanov"];
    
    NSArray* students = [NSArray arrayWithObjects:student1, student2, student3, student4, student5, student6,
                         student7, student8, student9, student10, student11, nil];
    
    NSArray* sortingListStudents = [students sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        AMStudent* studentFisrt = obj1;
        AMStudent* studentSecond = obj2;
        if (![studentFisrt.lastName compare:studentSecond.lastName] == NSOrderedSame) {
            return [studentFisrt.lastName compare:studentSecond.lastName];
        } else {
            return [studentFisrt.name compare:studentSecond.name];
        }
    }];
    
    for (AMStudent* student in sortingListStudents) {
        NSLog(@"%@ %@", student.lastName, student.name);
    }
    */
    
    void (^actionBlock)(AMPatient*) = ^(AMPatient* patient) {
        NSLog(@"patient - %@, temperature - %.2f",patient.name,patient.temperature);
        if (patient.temperature < 37.2f) {
            AMHurt hurt = [patient AreYouHurting];
            if (hurt != hurtNo) {
                [patient takePillOffHurt];
            } else {
                AMPressure pressure = [patient measurePressure];
                if (pressure == pressureLow) {
                    [patient takePillOnPressure];
                } else if (pressure == pressureHight) {
                    [patient takePillOffPressure];
                } else {
                    NSLog(@"Patient %@ is healthy", patient.name);
                }
            }
        } else if (patient.temperature >= 37.2f && patient.temperature < 39.f) {
            [patient takePillOffTemperature];
            AMHurt hurt = [patient AreYouHurting];
            if (hurt != hurtNo) {
                [patient takePillOffHurt];
                NSLog(@"Patient %@ need of the hospitalization",patient.name);
            }
        } else {
            NSLog(@"Patient %@ need of the hospitalization",patient.name);
        }
    };
    
    AMPatient* patient1 = [[AMPatient alloc] initWithName:@"Elly" diagnosticBlock:actionBlock];
    AMPatient* patient2 = [[AMPatient alloc] initWithName:@"Mik" diagnosticBlock:actionBlock];
    AMPatient* patient3 = [[AMPatient alloc] initWithName:@"Serg" diagnosticBlock:actionBlock];
    AMPatient* patient4 = [[AMPatient alloc] initWithName:@"Anna" diagnosticBlock:actionBlock];
    AMPatient* patient5 = [[AMPatient alloc] initWithName:@"Andrey" diagnosticBlock:actionBlock];

    self.patients = [NSArray arrayWithObjects:patient1, patient2, patient3, patient4, patient5, nil];

    
    /*
    for (AMPatient* patient in self.patients) {
        [patient feelsBad:actionBlock];
    }
    */
    return YES;
}


- (void) testExecuteBlock:(MyBlock) block {
    block();
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
