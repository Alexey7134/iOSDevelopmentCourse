//
//  AMPatient.h
//  12Bloks
//
//  Created by Admin on 30.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AMPatient;

typedef enum {
    hurtHight,
    hurtMiddle,
    hurtLow,
    hurtNo
} AMHurt;

typedef enum {
    pressureHight,
    pressureNormal,
    pressureLow
} AMPressure;

typedef enum {
    bodyPartHand,
    bodyPartHead,
    bodyPartBelly,
    bodyPartLeg,
    bodyPartHeart
} AMBodyPart;

typedef void (^DiagnosticBlock) (AMPatient*);

@interface AMPatient : NSObject

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) CGFloat temperature;

- (instancetype)initWithName:(NSString*)name diagnosticBlock:(DiagnosticBlock) actionBlock;

- (void) takePillOffTemperature;
- (void) takePillOffHurt;
- (void) takePillOffPressure;
- (void) takePillOnPressure;

- (AMPressure) measurePressure;

- (void) feelsBad:(DiagnosticBlock) actionBlock;
- (AMHurt) AreYouHurting;
- (void) becameWorse;
- (AMBodyPart) WhatHurts;


@end
