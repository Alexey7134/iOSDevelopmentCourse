//
//  AppDelegate.m
//  9Delegates
//
//  Created by Admin on 23.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AppDelegate.h"
#import "AMPatient.h"
#import "AMDoctor.h"
#import "AMFriend.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AMPatient* patient1 = [[AMPatient alloc] init];
    patient1.name = @"Elly";
    //patient1.temperature = 37.1f;
    
    AMPatient* patient2 = [[AMPatient alloc] init];
    patient2.name = @"Mik";
    //patient2.temperature = 38.4f;
    
    AMPatient* patient3 = [[AMPatient alloc] init];
    patient3.name = @"Serg";
    //patient3.temperature = 39.7f;
    
    AMPatient* patient4 = [[AMPatient alloc] init];
    patient4.name = @"Anna";
    //patient4.temperature = 36.6f;
    
    AMPatient* patient5 = [[AMPatient alloc] init];
    patient5.name = @"Andrey";
    //patient5.temperature = 37.5f;
    
    AMDoctor* doctor = [[AMDoctor alloc] init];
    doctor.name = @"dr. Anderson";
    AMFriend* bestFriend = [[AMFriend alloc] init];
    bestFriend.name = @"Billy";
    

    patient2.delegate = bestFriend;
    patient4.delegate = bestFriend;
    
   
    NSArray* patients = [NSArray arrayWithObjects:patient1, patient5, patient2, patient3, patient4, nil];
    for (AMPatient* patient in patients) {
        patient.delegate = doctor;
        [patient howAreYou];
        if (arc4random() % 2 && patient.temperature > 37.2f) {
            [patient becameWorse];
        }
    }
    
    [doctor printReportPartBody];
    
    for (AMPatient* patient in patients) {
        if (!patient.ratingDoctor) {
            patient.ratingDoctor = YES;
            if (patient.delegate == doctor) {
                patient.delegate = bestFriend;
            } else {
                patient.delegate = doctor;
            }
        }
    }
    
    
    for (AMPatient* patient in patients) {
        AMDoctor* delegate = patient.delegate;
        NSLog(@"%@",delegate.name);
    }
    
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
