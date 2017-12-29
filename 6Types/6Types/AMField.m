//
//  AMField.m
//  6Types
//
//  Created by Admin on 21.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMField.h"
#import <UIKit/UIKit.h>

@implementation AMField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.Shots = [[NSMutableArray alloc] init];
        self.Ships = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addRandomShot {
    CGPoint shot;
    NSInteger width = self.fieldSize.width;
    NSInteger height = self.fieldSize.height;
    shot = CGPointMake(self.fieldPoint.x + arc4random() % (width - 1) +1, self.fieldPoint.x + arc4random() % (height - 1) + 1);
    [self.Shots addObject:[NSValue valueWithCGPoint:shot]];
}

- (void) addShot: (CGPoint) shot {
    [self.Shots addObject:[NSValue valueWithCGPoint:shot]];
}


- (void) deleteShot: (CGPoint) shot {
    for (int i = 0; i < self.Shots.count; i++) {
        CGPoint currentShot = [[self.Shots objectAtIndex:i] CGPointValue];
        if (CGPointEqualToPoint(shot, currentShot)) {
            [self.Shots removeObjectAtIndex:i];
        }
    }
}



- (void) addRandomShip{
    CGRect ship;
    NSInteger width = self.fieldSize.width;
    NSInteger height = self.fieldSize.height;
    CGFloat x = arc4random() % (width - 1) + 1;
    CGFloat y = arc4random() % (height - 1) + 1;
    CGFloat randomWidth = arc4random() % 4 + 1;
    while (x + randomWidth > self.fieldPoint.x + width) {
        randomWidth = arc4random() % 4 + 1;
    }
    CGFloat randomHeight = arc4random() % 4 + 1;
    while (y + randomHeight > self.fieldPoint.y + height) {
        randomHeight = arc4random() % 4 + 1;
    }
    ship = CGRectMake(x, y, randomWidth, randomHeight);
    [self.Ships addObject:[NSValue valueWithCGRect:ship]];
}

/*
- (void) addShip: (CGRect) ship;
- (void) deleteShip: (CGRect) ship;

- (BOOL) pointInRect: (CGPoint) point rectange: (CGRect) rect;
*/

@end
