//
//  AMDoctor.m
//  10Notification
//
//  Created by Admin on 27.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMDoctor.h"
#import "AMGovernment.h"


@implementation AMDoctor

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(averagePriceChangeNoticifation:) name:AMGovernmentAveragePriceDidChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(salaryChangeNoticifation:) name:AMGovernmentSalaryDidChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) averagePriceChangeNoticifation:(NSNotification*) notification {
    
}

- (void) salaryChangeNoticifation:(NSNotification*) notification {
    CGFloat newSalary = [[notification.userInfo objectForKey:AMGovernmentSalaryUserInfoKey] floatValue];
    if (newSalary > self.salary) {
        NSLog(@"Doctor is very satisfied");
    } else {
        NSLog(@"Doctor is very satisfied");
    }
    self.salary = newSalary;
}

- (void) appWillResignActiveNotification: (UIApplication*) application {
    NSLog(@"Doctor will go to sleep");
}

- (void) appBecomeActiveNotification: (UIApplication*) application {
    NSLog(@"Doctor wakes up");
}

@end
