//
//  AMReport.m
//  9Delegates
//
//  Created by Admin on 25.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMReport.h"

@implementation AMReport

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.list = [[NSDictionary alloc] init];
    }
    return self;
}

@end
