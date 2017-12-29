//
//  AMField.h
//  6Types
//
//  Created by Admin on 21.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef enum {
    possible,
    impossible
} AMCrossing;

@interface AMField : NSObject

@property (assign, nonatomic) CGPoint fieldPoint;
@property (assign, nonatomic) CGSize fieldSize;

@property (assign, nonatomic) AMCrossing crossing;

@property (strong, nonatomic) NSMutableArray* Shots;
@property (strong, nonatomic) NSMutableArray* Ships;

- (void) addRandomShot;
- (void) addShot: (CGPoint) shot;
- (void) deleteShot: (CGPoint) shot;

- (void) addRandomShip;
/*
- (void) addShip: (CGRect) ship;
- (void) deleteShip: (CGRect) ship;

- (BOOL) pointInRect: (CGPoint) point rectange: (CGRect) rect;
*/
@end
