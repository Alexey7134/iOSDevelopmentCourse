//
//  AMDrawingPoint.h
//  24DrawingSuper
//
//  Created by Admin on 28.09.17.
//  Copyright © 2017 AMiksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMDrawingPoint : NSObject

@property (assign, nonatomic) CGPoint coordinate;
@property (strong, nonatomic) UIColor* color;
@property (assign, nonatomic) CGFloat width;

- (instancetype) initWithCoordinate:(CGPoint)point;

@end
