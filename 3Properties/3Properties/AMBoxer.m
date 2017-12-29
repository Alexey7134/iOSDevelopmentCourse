//
//  AMBoxer.m
//  3Properties
//
//  Created by Admin on 18.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMBoxer.h"

@implementation AMBoxer

@synthesize name = _name;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Anna";
        self.age = 33;
        self.height = 1.62f;
        self.weight = 58.2f;
    }
    return self;
}

-(void) setName:(NSString *)name {
    _name = name;
}

-(NSString*) name {
    return _name;
}

-(NSInteger) HowOldAreYou {
    return _age;
}

@end
