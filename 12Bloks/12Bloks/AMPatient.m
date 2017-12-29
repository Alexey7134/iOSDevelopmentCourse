//
//  AMPatient.m
//  12Bloks
//
//  Created by Admin on 30.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMPatient.h"

@implementation AMPatient

- (instancetype)initWithName:(NSString*)name diagnosticBlock:(DiagnosticBlock) actionBlock{
    self = [super init];
    if (self) {
        self.name = name;
        self.temperature = 36.5f + (float)(arc4random() % 31) / 10;
        [self performSelector:@selector(feelsBad:) withObject:actionBlock afterDelay:arc4random() % 15 + 5];
    }
    return self;
}

- (void) feelsBad:(DiagnosticBlock) actionBlock{
    actionBlock(self);
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

- (AMHurt) AreYouHurting{
    AMHurt hurt = arc4random() % 4;
    return hurt;
}

- (void) becameWorse {
    
}

- (AMBodyPart) WhatHurts {
    return arc4random() % 5;
}

@end
