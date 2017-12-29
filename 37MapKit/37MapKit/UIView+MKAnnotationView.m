//
//  UIView+MKAnnotationView.m
//  37MapKit
//
//  Created by Admin on 30.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "UIView+MKAnnotationView.h"

@implementation UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView {
    
    if (!self.superview) {
        return nil;
    }
    
    if ([self.superview isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView*)self.superview;
    }
    
    return [self.superview superAnnotationView];
    
}

@end
