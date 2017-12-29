//
//  AMDataManager.h
//  41CoreData
//
//  Created by Admin on 10.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSPersistentContainer;
@class AMStudent;

@interface AMDataManager : NSObject

@property (readonly, strong) NSPersistentContainer* persistentContainer;


+ (AMDataManager*) sharedManager;

- (void)saveContext;

@end
