//
//  AMDataManager.m
//  41CoreData
//
//  Created by Admin on 10.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDataManager.h"
#import <CoreData/CoreData.h>
#import "AMStudent+CoreDataClass.h"

@implementation AMDataManager

+ (AMDataManager*) sharedManager {
    
    static AMDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AMDataManager alloc] init];
    });
    
    return manager;
    
}

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {

    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"_1CoreData"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

- (void)saveContext {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
        
    }
    
}

@end
