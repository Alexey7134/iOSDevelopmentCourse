//
//  AppDelegate.m
//  13Multithreading
//
//  Created by Admin on 02.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AppDelegate.h"
#import "AMStudent.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSArray* arrayOfStudents;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    AMStudent* student1 = [[AMStudent alloc] init];
    student1.name = @"Valya";
    
    AMStudent* student2 = [[AMStudent alloc] init];
    student2.name = @"Nikki";
    
    AMStudent* student3 = [[AMStudent alloc] init];
    student3.name = @"Maxim";
    
    AMStudent* student4 = [[AMStudent alloc] init];
    student4.name = @"Alexandr";
    
    AMStudent* student5 = [[AMStudent alloc] init];
    student5.name = @"Rossy";
    
    self.arrayOfStudents = [NSArray arrayWithObjects:student1, student2, student3, student4, student5, nil];
   
    /*
    for (AMStudent* student in arrayOfStudents) {
        [student guessNumberInRange:150 endOfRange:50000];
    }
    */
    
    for (AMStudent* student in self.arrayOfStudents) {
        __weak AMStudent* weakSelf = student;
        [student guessNumberInRange:15 endOfRange:10000000 showResult:^(CGFloat second) {
            NSLog(@"Student %@ guessed number of %f second", weakSelf.name, second);
        }];
    };
    
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
