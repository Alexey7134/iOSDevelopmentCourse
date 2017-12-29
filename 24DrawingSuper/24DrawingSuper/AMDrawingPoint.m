//
//  AMDrawingPoint.m
//  24DrawingSuper
//
//  Created by Admin on 28.09.17.
//  Copyright © 2017 AMiksiuk. All rights reserved.
//

#import "AMDrawingPoint.h"

@implementation AMDrawingPoint

- (instancetype) initWithCoordinate:(CGPoint)point {
    self = [super init];
    if (self) {
        self.coordinate = point;
        self.color = [UIColor blackColor];
        self.width = 1.f;
    }
    return self;
}

@end
