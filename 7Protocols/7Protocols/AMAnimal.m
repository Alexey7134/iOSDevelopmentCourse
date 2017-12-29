//
//  AMAnimal.m
//  5Arrays1
//
//  Created by Admin on 20.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMAnimal.h"

@implementation AMAnimal


- (void) Moves{
    NSLog(@"%@ is moves", self.name);
}

- (instancetype)initWithParameters: (NSString*) name breed:(NSString*) breed age:(NSInteger) age isWild:(BOOL) wild
{
    self = [super init];
    if (self) {
        self.name = name;
        self.breed = breed;
        self.age = age;
        self.wild = wild;
    }
    return self;
}

@end
