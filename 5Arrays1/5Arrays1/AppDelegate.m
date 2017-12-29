//
//  AppDelegate.m
//  5Arrays1
//
//  Created by Admin on 20.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AppDelegate.h"
#import "AMHuman.h"
#import "AMCyclist.h"
#import "AMRunner.h"
#import "AMSwimmer.h"
#import "AMDancer.h"
#import "AMAnimal.h"
#import "AMCat.h"
#import "AMDog.h"
#import "AMWolf.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    AMCyclist* cyclist = [[AMCyclist alloc] initWithParameters:@"Anna" gender:@"female" height:1.65f weight:54.3f];
    
    AMRunner* runner = [[AMRunner alloc] initWithParameters:@"Max" gender:@"male" height:1.89f weight:84.3f];
    
    AMSwimmer* swimmer = [[AMSwimmer alloc] initWithParameters:@"Elsa" gender:@"female" height:1.75f weight:62.f];
    
    AMDancer* dancer = [[AMDancer alloc] initWithParameters:@"Elena" gender:@"female" height:1.68f weight:54.f];
    dancer.styleOfDance = @"breakdance";
    
    
    AMCat* cat = [[AMCat alloc] initWithParameters:@"Harry" breed:@"Pers" age:1 isWild:NO];
    AMDog* dog = [[AMDog alloc] initWithParameters:@"Rex" breed:@"Sheepdog" age:3 isWild:NO];
    AMWolf* wolf = [[AMWolf alloc] initWithParameters:@"Wofl" breed:@"grey" age:5 isWild:YES];
    
    NSArray* objects = [NSArray arrayWithObjects: cyclist, dog, runner, swimmer, wolf, dancer, cat, nil];
    
    NSArray* sortedObjects = [objects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        if ([obj1 isKindOfClass:[AMHuman class]] && [obj2 isKindOfClass:[AMAnimal class]]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else if ([obj1 isKindOfClass:[AMAnimal class]] && [obj2 isKindOfClass:[AMHuman class]]){
                return (NSComparisonResult)NSOrderedDescending;
            }
            else if ([obj1 isKindOfClass:[AMHuman class]] && [obj2 isKindOfClass:[AMHuman class]]) {
                    AMHuman* human1 = (AMHuman*) obj1;
                    AMHuman* human2 = (AMHuman*) obj2;
                    return [human1.name compare:human2.name];
                }
                else if ([obj1 isKindOfClass:[AMAnimal class]] && [obj2 isKindOfClass:[AMAnimal class]]) {
                        AMAnimal* animal1 = (AMAnimal*) obj1;
                        AMAnimal* animal2 = (AMAnimal*) obj2;
                        return [animal1.name compare:animal2.name];
                    }
                    else {
                        return (NSComparisonResult)NSOrderedSame;
                    }
    }];
    
    for (NSObject* element in sortedObjects) {
        if ([element isKindOfClass:[AMHuman class]]) {
            AMHuman* elementOfList = (AMHuman*) element;
            NSLog(@"human - %@, gender - %@, height - %.2f, weight - %.2f",elementOfList.name, elementOfList.gender, elementOfList.height, elementOfList.weight);
        }
        else if ([element isKindOfClass:[AMAnimal class]]) {
            AMAnimal* elementOfList = (AMAnimal*) element;
            NSLog(@"animal - %@, breed - %@, age - %d",elementOfList.name, elementOfList.breed, elementOfList.age);
        }
    }
    
    /*
    NSArray* humans = [NSArray arrayWithObjects: man, cyclist, runner, swimmer, dancer, nil];
    NSArray* animals = [NSArray arrayWithObjects: cat, dog, wolf, nil];
    int countMax = 0;
    
    if ([humans count] > [animals count]) {
        countMax = [humans count];
    }
    else {
        countMax = [animals count];
    }
    
    for (int i = 0; i < countMax; i++) {
        if (i < [humans count]) {
            AMHuman* human = [humans objectAtIndex:i];
            NSLog(@"name - %@, sex - %@, height - %.2f, weight - %.2f",human.name, human.sex, human.height, human.weight);
            [human Moves];
        }
        if (i < [animals count]) {
            AMAnimal* animal = [animals objectAtIndex:i];
            NSLog(@"name - %@, breed - %@, age - %d",animal.name, animal.breed, animal.age);
            [animal Moves];
        }
    }
    */
    
    /*
    NSArray* listOfObjects = [NSArray arrayWithObjects: man, cyclist, cat, runner, swimmer, wolf, dancer, dog, nil];
    for (NSObject* element in listOfObjects) {
        if ([element isKindOfClass:[AMHuman class]]) {
            NSLog(@"Human");
            AMHuman* elementOfList = (AMHuman*) element;
            NSLog(@"name - %@, sex - %@, height - %.2f, weight - %.2f",elementOfList.name, elementOfList.sex, elementOfList.height, elementOfList.weight);
            [elementOfList Moves];
        }
        else if ([element isKindOfClass:[AMAnimal class]]) {
            NSLog(@"Animal");
            AMAnimal* elementOfList = (AMAnimal*) element;
            NSLog(@"name - %@, breed - %@, age - %d",elementOfList.name, elementOfList.breed, elementOfList.age);
            if (elementOfList.wild) {
                NSLog(@"Animal is wild");
            }
            else {
                NSLog(@"Animal is domiciliary");
            }
            [elementOfList Moves];
        }
        
    }
    */
    
    /*
    NSArray* listOfHuman = [NSArray arrayWithObjects: man, cyclist, runner, dancer, swimmer, nil];
    for (AMHuman* elementOfList in listOfHuman) {
        NSLog(@"name - %@, sex - %@, height - %.2f, weight - %.2f",elementOfList.name, elementOfList.sex, elementOfList.height, elementOfList.weight);
        if ([elementOfList isKindOfClass:[AMDancer class]]) {
            AMDancer* elementDancer = (AMDancer*) elementOfList;
            NSLog(@"%@ is dancer in style %@",elementDancer.name,elementDancer.styleOfDance);
        }
        [elementOfList Moves];
    }
    */
    
    /*
    NSArray* listOfHuman = [NSArray arrayWithObjects: man, cyclist, runner, dancer, swimmer, nil];
    for (int i = [listOfHuman count]-1; i >= 0; i--) {
        AMHuman* elementOfList = [listOfHuman objectAtIndex: i];
        NSLog(@"name - %@, sex - %@, height - %.2f, weight - %.2f",elementOfList.name, elementOfList.sex, elementOfList.height, elementOfList.weight);
        if ([elementOfList isKindOfClass:[AMDancer class]]) {
            AMDancer* elementDancer = (AMDancer*) elementOfList;
            NSLog(@"%@ is dancer in style %@",elementDancer.name,elementDancer.styleOfDance);
        }
        [elementOfList Moves];

    }
    */
    
    
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
