//
//  AMStudent.m
//  12Bloks
//
//  Created by Admin on 29.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudent.h"

@implementation AMStudent

- (instancetype)initWithName:(NSString*)name lastName:(NSString*)lastName {
    self = [super init];
    if (self) {
        self.name = name;
        self.lastName = lastName;
    }
    return self;
}

@end
