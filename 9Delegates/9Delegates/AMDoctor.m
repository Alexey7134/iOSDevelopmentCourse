//
//  AMDoctor.m
//  9Delegates
//
//  Created by Admin on 23.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDoctor.h"


@implementation AMDoctor

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reportPartBody = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) printReportPartBody {
    NSArray* allkeys = [self.reportPartBody allKeys];
    for (NSString* key in allkeys) {
        NSLog(@"Part body - %@", key);
        NSMutableArray* arrayName =[self.reportPartBody objectForKey:key];
        for (NSString* name in arrayName) {
            NSLog(@"%@",name);
        }
    }
}

#pragma mark -AMPatientDelegate

- (void) patientFeelsBad:(AMPatient *)patient {

    if (patient.temperature < 37.2f) {
        AMHurt hurt = [patient AreYouHurting];
        if (hurt != hurtNo) {
            [patient takePillOffHurt];
            
            AMBodyPart bodyPart = [patient WhatHurts];
            NSString* bodyPartKey = [self getBodyPartHurtsName:bodyPart];
            NSArray* allKeys = [self.reportPartBody allKeys];
            
            if ([allKeys containsObject:bodyPartKey]) {
                NSMutableArray* arrayName = [self.reportPartBody objectForKey:bodyPartKey];
                [arrayName addObject:patient.name];
            } else {
                NSMutableArray* arrayName = [[NSMutableArray alloc] init];
                [arrayName addObject:patient.name];
                [self.reportPartBody setObject:arrayName forKey:bodyPartKey];
            }
        } else {
            AMPressure pressure = [patient measurePressure];
            if (pressure == pressureLow) {
                [patient takePillOnPressure];
            } else if (pressure == pressureHight) {
                [patient takePillOffPressure];
            } else {
                NSLog(@"Patient %@ is healthy", patient.name);
            }
        }
    } else if (patient.temperature >= 37.2f && patient.temperature < 39.f) {
        [patient takePillOffTemperature];
        AMHurt hurt = [patient AreYouHurting];
        if (hurt != hurtNo) {
            [patient takePillOffHurt];
            AMBodyPart bodyPart = [patient WhatHurts];
            NSString* bodyPartKey = [self getBodyPartHurtsName:bodyPart];
            NSArray* allKeys = [self.reportPartBody allKeys];
            
            if ([allKeys containsObject:bodyPartKey]) {
                NSMutableArray* arrayName = [self.reportPartBody objectForKey:bodyPartKey];
                [arrayName addObject:patient.name];
            } else {
                NSMutableArray* arrayName = [[NSMutableArray alloc] init];
                [arrayName addObject:patient.name];
                [self.reportPartBody setObject:arrayName forKey:bodyPartKey];
            }
            
            NSLog(@"Patient %@ need of the hospitalization",patient.name);
        }
    } else {
        NSLog(@"Patient %@ need of the hospitalization",patient.name);
    }
    NSInteger rating = arc4random() % 3;
    if (rating == 0) {
        patient.ratingDoctor = NO;
    }
}

- (void) patientFeelsBad:(AMPatient *)patient ofHurt:(AMHurt)hurt {
    if (patient.temperature < 37.2f) {
        [patient takePillOffHurt];
    } else {
        [patient takePillOffHurt];
        NSLog(@"Patient %@ need of the hospitalization",patient.name);
    }
}

- (void)patientFeelsBecameWorse:(AMPatient *)patient {
    NSLog(@"Patient %@ quickly go to the hospital", patient.name);
}

#pragma mark - PrivateFunction

- (NSString*) getBodyPartHurtsName: (AMBodyPart) bodyPart{
    switch (bodyPart) {
        case bodyPartBelly :
            return @"Belly";
        case bodyPartHand:
            return @"Hand";
        case bodyPartHead:
            return @"Head";
        case bodyPartHeart:
            return @"Heart";
        case bodyPartLeg:
            return @"Leg";
        default:
            return @"";
    }
}

@end
