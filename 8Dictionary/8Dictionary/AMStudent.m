//
//  AMStudent.m
//  8Dictionary
//
//  Created by Admin on 22.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudent.h"

@implementation AMStudent

- (instancetype) initWithName: (NSString*) firstName lastName: (NSString*) lastName welcome: (NSString*) welcome {
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.welcome = welcome;
    }
    return self;
}

@end
