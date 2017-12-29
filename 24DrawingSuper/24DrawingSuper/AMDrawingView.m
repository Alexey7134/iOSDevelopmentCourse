//
//  AMDrawingView.m
//  24DrawingSuper
//
//  Created by Admin on 27.09.17.
//  Copyright © 2017 AMiksiuk. All rights reserved.
//

#import "AMDrawingView.h"
#import "AMDrawingPoint.h"

@implementation AMDrawingView


- (void)drawRect:(CGRect)rect {
    
    
    if (self.drawnPoints) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        for (NSInteger i = 0; i < [self.drawnPoints count]; i++) {
            AMDrawingPoint* drawnPoint = [self.drawnPoints objectAtIndex:i];
            CGPoint point = drawnPoint.coordinate;
            if (CGRectContainsPoint(rect, point)) {
                CGContextSetFillColorWithColor(context, drawnPoint.color.CGColor);
                CGContextAddEllipseInRect(context, CGRectMake(point.x,
                                                              point.y, drawnPoint.width, drawnPoint.width));
                CGContextFillPath(context);
            }
        }
    }
}


@end
