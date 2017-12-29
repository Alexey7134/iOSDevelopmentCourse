//
//  AMAnimal.h
//  5Arrays1
//
//  Created by Admin on 20.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMAnimal : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* breed;
@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) BOOL wild;

- (instancetype)initWithParameters: (NSString*) name breed:(NSString*) breed age:(NSInteger) age isWild:(BOOL) wild;
- (void) Moves;

@end
