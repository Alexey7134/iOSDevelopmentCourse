//
//  AppDelegate.m
//  10Notification
//
//  Created by Admin on 26.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AppDelegate.h"
#import "AMGovernment.h"
#import "AMDoctor.h"
#import "AMBussinesMan.h"
#import "AMRetired.h"
#import "AMCatcher.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    AMGovernment* government = [[AMGovernment alloc] init];
    self.doctor = [[AMDoctor alloc] init];
    self.bussinesMan = [[AMBussinesMan alloc] init];
    self.retired = [[AMRetired alloc] init];
    self.catcher = [[AMCatcher alloc] init];

    self.doctor.name = @"Anderson";
    self.bussinesMan.firstName = @"Patric";
    self.bussinesMan.lastName = @"Dominic";
    self.bussinesMan.profit = 1560.f;
    self.retired.name = @"King";
    self.retired.inflation = 0.f;
    self.retired.pension = 256.32f;

    
    [government changeTaxRate];
    [government changeTaxRate];
    [government changeAveragePrice];
    [government changeTaxRate];
    [government changePension];
    [government changeSalary];
    [government changeAveragePrice];
    [government changePension];
    [government changeSalary];
    [government changeAveragePrice];
    [government changePension];
    
    NSLog(@"pensia - %.2f, inflation = %f",self.retired.pension, self.retired.inflation);
    
    
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"Application going to sleep");
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
    NSLog(@"Application activated");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
