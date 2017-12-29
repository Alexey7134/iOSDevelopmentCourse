//
//  AMDrawingView.m
//  24Drawing
//
//  Created by Admin on 24.09.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDrawingView.h"

@implementation AMDrawingView

- (void) drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    
    for (NSInteger numberStar = 0; numberStar < 5; numberStar++) {
   
        NSInteger radius = arc4random() % 50 + 20;

        CGPoint center = CGPointMake((float)(arc4random() % ((int)CGRectGetWidth(rect) - 2*50) + 50), (float)(arc4random() % ((int)CGRectGetHeight(rect) - 2*50) + 50));

        CGContextSetFillColorWithColor(context, [self randomCGColor]);

        NSMutableArray* starPoints = [self getPointsStarInCenter:center withRadius:radius countAngle:5];
        CGContextMoveToPoint(context, [[starPoints objectAtIndex:0] CGPointValue].x, [[starPoints objectAtIndex:0] CGPointValue].y);

        for (NSInteger i = 1; i < [starPoints count]; i++) {
            CGContextAddLineToPoint(context, [[starPoints objectAtIndex:i] CGPointValue].x, [[starPoints objectAtIndex:i] CGPointValue].y);
        }

        CGContextFillPath(context);

        CGContextSetFillColorWithColor(context, [self randomCGColor]);
        for (NSInteger i = 0; i < [starPoints count]; i++) {
            if (i % 2 == 0) {
                CGRect rect = CGRectMake([[starPoints objectAtIndex:i] CGPointValue].x - 4, [[starPoints objectAtIndex:i] CGPointValue].y - 4, 8, 8);
                CGContextFillEllipseInRect(context, rect);
            }
        }

        CGContextSetStrokeColorWithColor(context, [self randomCGColor]);
        CGContextMoveToPoint(context, [[starPoints objectAtIndex:0] CGPointValue].x, [[starPoints objectAtIndex:0] CGPointValue].y);
        for (NSInteger i = 1; i < [starPoints count]; i++) {
            if (i % 2 == 0) {
                CGContextAddLineToPoint(context, [[starPoints objectAtIndex:i] CGPointValue].x, [[starPoints objectAtIndex:i] CGPointValue].y);
            }
        }
        CGContextAddLineToPoint(context, [[starPoints objectAtIndex:0] CGPointValue].x, [[starPoints objectAtIndex:0] CGPointValue].y);
        CGContextStrokePath(context);
        
    }
    
    /*
    
    NSInteger radius = 30;
    for (NSInteger i = 0; i < 7; i++) {
        CGFloat startAngle = (float)(arc4random() % 315) / 100.f;
        CGFloat clearAngle = 1.f / (i + 1);
        CGFloat endAngle = startAngle + clearAngle;
        
        CGContextSetStrokeColorWithColor(context, [self randomCGColor]);
        CGContextSetLineWidth(context, 3);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextAddArc(context, CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2, radius, startAngle, endAngle, YES);
        CGContextStrokePath(context);
 
        radius += 20;
    }
    */
}

#pragma mark - Additional Function

- (NSMutableArray*) getPointsStarInCenter:(CGPoint)center withRadius:(NSInteger)radius countAngle:(NSInteger)countAngle {
    
    CGFloat stepAngle = 2 * M_PI / countAngle;
    
    NSMutableArray* arrayVertex = [[NSMutableArray alloc] init];
    
    for (CGFloat angle = 0; angle < 2 * M_PI; angle = angle + stepAngle) {
        NSInteger offsetX = radius * cos(angle);
        NSInteger offsetY = radius * sin(angle);
        CGPoint point = CGPointMake(center.x + offsetX, center.y - offsetY);
        [arrayVertex addObject:[NSValue valueWithCGPoint:point]];
    }

    NSMutableArray* arrayIntersection = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [arrayVertex count]; i++) {
        NSInteger i2 = (i + 2 < [arrayVertex count]) ? i + 2 : i + 2 - [arrayVertex count];
        NSInteger j = (i + 1 < [arrayVertex count]) ? i + 1 : i + 1 - [arrayVertex count];
        NSInteger j2 = (i - 1 >= 0) ? i - 1 : [arrayVertex count] - 1;
        CGPoint pointIntersection = [self getCoordinateIntersecitonSegmentsWithOnePoint:[[arrayVertex objectAtIndex:i] CGPointValue]
                                                                    twoPoint:[[arrayVertex objectAtIndex:i2] CGPointValue]
                                                                  threePoint:[[arrayVertex objectAtIndex:j] CGPointValue]
                                                                   fourPoint:[[arrayVertex objectAtIndex:j2] CGPointValue]];
        [arrayIntersection addObject:[NSValue valueWithCGPoint:pointIntersection]];
    }
    
    NSMutableArray* points = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [arrayVertex count]; i++) {
        [points addObject:[arrayVertex objectAtIndex:i]];
        [points addObject:[arrayIntersection objectAtIndex:i]];
    }

    return points;
    
}

- (CGPoint) getCoordinateIntersecitonSegmentsWithOnePoint:(CGPoint)point1 twoPoint:(CGPoint)point2 threePoint:(CGPoint)point3 fourPoint:(CGPoint)point4 {
    
    CGFloat deltaX21 = point2.x - point1.x;
    CGFloat deltaY21 = point2.y - point1.y;
    CGFloat deltaX43 = point4.x - point3.x;
    CGFloat deltaY43 = point4.y - point3.y;

    if (deltaY43 * deltaX21 != deltaX43 * deltaY21) {

        NSInteger x = (deltaX43*deltaX21*point1.y - deltaX43*deltaY21*point1.x + deltaY43*deltaX21*point3.x - deltaX21*deltaX43*point3.y) / (deltaY43 * deltaX21 - deltaX43 * deltaY21);
        if (deltaX21 != 0) {
            NSInteger y = (deltaY21*x - deltaY21*point1.x + deltaX21*point1.y) / deltaX21;
            return CGPointMake(x, y);
        } else if (deltaX43 != 0){
                    NSInteger y = (deltaY43*x - deltaY43*point3.x + deltaX43*point3.y) / deltaX43;
                    return CGPointMake(x, y);
                } else {
                    return CGPointZero;
                }
    }
    
    return CGPointZero;
    
}

- (CGColorRef) randomCGColor {
    
    UIColor* color = [UIColor colorWithRed:(float)(arc4random() % 256) / 255.f green:(float)(arc4random() % 256) / 255.f blue:(float)(arc4random() % 256) / 255.f alpha:1.f];
    
    return color.CGColor;
    
}

@end
