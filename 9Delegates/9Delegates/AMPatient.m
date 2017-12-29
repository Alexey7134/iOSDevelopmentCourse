//
//  AMPatient.m
//  9Delegates
//
//  Created by Admin on 23.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMPatient.h"

@implementation AMPatient

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.temperature = 36.5f + (arc4random() % 31) / 10;
        self.ratingDoctor = YES;
    }
    return self;
}

- (void) takePillOffTemperature {
    NSLog(@"Patient %@ take pill off the temperature", self.name);
}

- (void) takePillOffHurt{
    NSLog(@"Patient %@ take pill off the hurt", self.name);
}

- (void) takePillOffPressure {
    NSLog(@"Patient %@ take pill off the hight pressure", self.name);
}

- (void) takePillOnPressure {
    NSLog(@"Patient %@ take pill off the low pressure", self.name);
}

- (AMPressure) measurePressure {
    return arc4random() % 4;
}

- (BOOL) howAreYou{
    [self.delegate patientFeelsBad:self];
    return NO;
    /*
    NSInteger how = arc4random() % 2;
    if (!how) {
        [self.delegate patientFeelsBad:self];
    }
    return how;
     */
}

- (AMHurt) AreYouHurting{
    AMHurt hurt = arc4random() % 4;
    return hurt;
}

- (void) becameWorse {
    [self.delegate patientFeelsBecameWorse:self];
}

- (AMBodyPart) WhatHurts {
    return arc4random() % 5;
}

@end
