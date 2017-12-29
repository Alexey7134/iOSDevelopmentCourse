//
//  AppDelegate.m
//  15BitwiseOperations
//
//  Created by Admin on 06.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AppDelegate.h"
#import "AMStudent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSMutableArray* Students = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 10; i ++) {
        AMStudent* student = [[AMStudent alloc] init];
        NSUInteger random = arc4random() % 256;
        student.subjectType = (AMStudentSubjectType)random;
        [Students addObject:student];
    }
    
    for (AMStudent* student in Students) {
        NSLog(@"%@", student);
    }
    
    NSMutableArray* techStudents = [[NSMutableArray alloc] init];
    NSMutableArray* humStudents = [[NSMutableArray alloc] init];
    
    NSInteger countStudyingProgramming = 0;
    
    for (AMStudent* student in Students) {
        if (student.subjectType & AMStudentSubjectTypeProgramming) {
            countStudyingProgramming++;
        }
        if (student.subjectType & AMStudentSubjectTypeMath && student.subjectType & AMStudentSubjectTypePhysics &&
            student.subjectType & AMStudentSubjectTypeProgramming && student.subjectType & AMStudentSubjectTypeChemistry) {
            [techStudents addObject:student];
        } else {
            [humStudents addObject:student];
        }
    }
    
    NSLog(@"-----Techinicial students:-------");
    for (AMStudent* student in techStudents) {
        NSLog(@"%@", student);
    }
    
    NSLog(@"-----Humanitary students:-------");
    for (AMStudent* student in humStudents) {
        NSLog(@"%@", student);
    }
    
    NSLog(@"%d students studies programming", countStudyingProgramming);
    
    for (AMStudent* student in Students) {
        if (student.subjectType & AMStudentSubjectTypeBiology) {
            student.subjectType = student.subjectType & ~AMStudentSubjectTypeBiology;   //canceled bit biology
            NSLog(@"Study biology canceled");
        }
    }
    
    NSInteger randomNumber = arc4random() % 0x7ffffff;
    NSLog(@"decimal - %d",randomNumber);

    NSMutableString* binaryRandomNumber = [[NSMutableString alloc] init];

    for (NSInteger i = 0; i < 32; i++) {
        NSInteger mask = 1 << i;
        [binaryRandomNumber insertString:randomNumber & mask ? @"1" : @"0" atIndex:0];
    }
    
    NSLog(@"binary - %@", binaryRandomNumber);
    
    return YES;
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
