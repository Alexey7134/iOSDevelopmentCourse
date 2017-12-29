//
//  AMMeetingPlace.m
//  37MapKit
//
//  Created by Admin on 29.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMMeetingPlace.h"

@implementation AMMeetingPlace

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
    }
    return self;
}

@end
