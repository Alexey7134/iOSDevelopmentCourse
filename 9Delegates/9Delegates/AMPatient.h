//
//  AMPatient.h
//  9Delegates
//
//  Created by Admin on 23.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol AMPatientDelegate;

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

@interface AMPatient : NSObject

@property (weak, nonatomic) id <AMPatientDelegate> delegate;

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) CGFloat temperature;
@property (assign, nonatomic) BOOL ratingDoctor;


- (void) takePillOffTemperature;
- (void) takePillOffHurt;
- (void) takePillOffPressure;
- (void) takePillOnPressure;

- (AMPressure) measurePressure;

- (BOOL) howAreYou;
- (AMHurt) AreYouHurting;
- (void) becameWorse;
- (AMBodyPart) WhatHurts;

@end

@protocol AMPatientDelegate <NSObject>

@required

- (void) patientFeelsBad: (AMPatient*) patient;
- (void) patientFeelsBecameWorse:(AMPatient *)patient;

@optional

- (void) patientFeelsBad:(AMPatient *)patient ofHurt:(AMHurt) hurt;


@end
