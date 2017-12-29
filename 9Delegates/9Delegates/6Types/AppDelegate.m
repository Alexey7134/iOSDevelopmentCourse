//
//  AppDelegate.m
//  6Types
//
//  Created by Admin on 21.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AppDelegate.h"
#import "AMField.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    AMField* myField = [[AMField alloc] init];
    
    myField.fieldPoint = CGPointMake(0, 0);
    myField.fieldSize = CGSizeMake(20, 20);
    
    [myField addRandomShot];
    [myField addShot:CGPointMake(15, 2)];
    [myField addRandomShot];
    [myField addRandomShot];
    
    [myField addRandomShip];
    [myField addRandomShip];
    [myField addRandomShip];
    
    //NSLog(@"%d",myField.Shots.count);
    
    for (int i = 0; i <  myField.Shots.count; i++) {
        NSLog(@"x = %f, y = %f",[[myField.Shots objectAtIndex:i ] CGPointValue].x,
              [[myField.Shots objectAtIndex:i ] CGPointValue].y);
    }
    
    for (int i = 0; i <  myField.Ships.count; i++) {
        NSLog(@"x = %f, y = %f, w = %f, h = %f",[[myField.Ships objectAtIndex:i ] CGRectValue].origin.x,
              [[myField.Ships objectAtIndex:i ] CGRectValue].origin.y, [[myField.Ships objectAtIndex:i ] CGRectValue].size.width,
              [[myField.Ships objectAtIndex:i ] CGRectValue].size.height);
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
