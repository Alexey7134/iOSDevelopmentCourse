//
//  AMHuman.m
//  5Arrays1
//
//  Created by Admin on 20.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMHuman.h"

@implementation AMHuman

- (void) Moves{
    NSLog(@"%@ is movement", self.name);
}

- (instancetype)initWithParameters: (NSString*) name gender:(NSString*) gender height:(float) height weight:(float) weight
{
    self = [super init];
    if (self) {
        self.name = name;
        self.gender = gender;
        self.height = height;
        self.weight = weight;
    }
    return self;
}

@end
