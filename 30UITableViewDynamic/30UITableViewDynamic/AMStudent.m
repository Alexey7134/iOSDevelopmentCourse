//
//  AMStudent.m
//  30UITableViewDynamic
//
//  Created by Admin on 09.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMStudent.h"

@implementation AMStudent

- (instancetype)initWithName:(NSString*)firstName lastName:(NSString*)lastName averageScore:(CGFloat)averageScore {
    
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.averageScore = averageScore;
        self.level = AMLevelNone;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ score - %f, level - %d", self.lastName, self.firstName, self.averageScore, self.level];
}

@end
