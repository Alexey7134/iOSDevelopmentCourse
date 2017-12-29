//
//  AppDelegate.m
//  8Dictionary
//
//  Created by Admin on 22.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AppDelegate.h"
#import "AMStudent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    AMStudent* petrov = [[AMStudent alloc] initWithName:@"Alex" lastName:@"Petrov" welcome:@"Your welcome"];
    AMStudent* ivanov = [[AMStudent alloc] initWithName:@"Petr" lastName:@"Ivanov" welcome:@"Greeting"];
    AMStudent* sidorov = [[AMStudent alloc] initWithName:@"Max" lastName:@"Sidorov" welcome:@"Welcome!!!!"];
    AMStudent* volk = [[AMStudent alloc] initWithName:@"Sergey" lastName:@"Volk" welcome:@"Are you ready???"];
    AMStudent* lis = [[AMStudent alloc] initWithName:@"Andrey" lastName:@"Lis" welcome:@"Hello"];
    
    NSDictionary* journal = [NSDictionary dictionaryWithObjectsAndKeys:
                             petrov, [NSString stringWithFormat:petrov.lastName, @" ",petrov.firstName],
                             ivanov, [NSString stringWithFormat:ivanov.lastName, @" ",ivanov.firstName],
                             sidorov, [NSString stringWithFormat:sidorov.lastName, @" ",sidorov.firstName],
                             volk, [NSString stringWithFormat:volk.lastName, @" ",volk.firstName],
                             lis, [NSString stringWithFormat:lis.lastName, @" ",lis.firstName],
                             nil];
    
    //NSLog(@"%@", journal);
    /*
    for (NSString* key in [journal allKeys]) {
        AMStudent* student = [journal objectForKey:key];
        NSLog(@"%@ %@: %@",student.lastName, student.firstName, student.welcome);
    }
    */

    NSSortDescriptor* SortKeyName = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
    NSArray* arrayKeys = [journal allKeys];
    
    NSArray* sortedArrayKeys = [arrayKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:SortKeyName]];

    for (NSString* key in sortedArrayKeys) {
        AMStudent* student = [journal objectForKey:key];
        NSLog(@"%@ %@: %@",student.lastName, student.firstName, student.welcome);
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
