//
//  AMFriend.m
//  9Delegates
//
//  Created by Admin on 24.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMFriend.h"


@implementation AMFriend

#pragma mark - AMPatientDelegate

- (void) patientFeelsBad: (AMPatient*) patient {
    NSLog(@"Patient %@ needs on vacation", patient.name);
}

- (void) patientFeelsBad: (AMPatient*) patient ofPressure: (AMPressure) pressure {
    NSLog(@"Patient %@ take a pill", patient.name);
}

- (void) patientFeelsBad:(AMPatient *)patient ofHurt:(AMHurt) hurt {
    if (hurt != hurtNo) {
        [patient takePillOffHurt];
    }
}

- (void) patientFeelsBecameWorse:(AMPatient *)patient {
    NSLog(@"Patient %@ needs of the doctor", patient.name);
}

@end
