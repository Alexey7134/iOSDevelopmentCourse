//
//  UIColor+AMCustomColor.m
//  45ClientServerAPIBasic
//
//  Created by Admin on 05.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "UIColor+AMCustomColor.h"

@implementation UIColor (AMCustomColor)

+ (UIColor*) orangeCustomColor {
    
    return [UIColor colorWithRed:(float)253/256.f green:(float)176/256.f blue:(float)120/256.f alpha:1.f];
    
}

+ (UIColor*) yellowCustomColor {
    
    return [UIColor colorWithRed:(float)248/256.f green:(float)225/256.f blue:(float)148/256.f alpha:1.f];

}

+ (UIColor*) pinkCustomColor {
    
    return [UIColor colorWithRed:(float)243/256.f green:(float)97/256.f blue:(float)116/256.f alpha:1.f];

}

+ (UIColor*) lightGrayCustomColor {

    return [UIColor colorWithRed:(float)241/256.f green:(float)239/256.f blue:(float)241/256.f alpha:1.f];

}

+ (UIColor*) marineCustomColor {
    
    return [UIColor colorWithRed:(float)43/256.f green:(float)155/256.f blue:(float)158/256.f alpha:1.f];

}

@end
