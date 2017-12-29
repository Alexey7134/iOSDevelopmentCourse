//
//  AMBussinesMan.m
//  10Notification
//
//  Created by Admin on 27.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMBussinesMan.h"
#import "AMGovernment.h"

@implementation AMBussinesMan

- (CGFloat) calculateIncome:(CGFloat)taxRate {
    return self.profit - (CGFloat)self.profit * taxRate / 100;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxRateChangeNotification:) name:AMGovernmentTaxRateDidChange object:nil];
        [[NSNotificationCenter defaultCenter]    addObserver:self selector:@selector(averagePriceChangeNotification:) name:AMGovernmentAveragePriceDidChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) taxRateChangeNotification:(NSNotification*)notification {
    CGFloat newIncome = [self calculateIncome:
                         [[notification.userInfo objectForKey:AMGovernmentTaxRateUserInfoKey] floatValue]];
    if (newIncome > self.income) {
        NSLog(@"Bussinesman %@ %@ says it's a good change", self.lastName, self.firstName);
    } else if (newIncome == self.income) {
        NSLog(@"Bussinesman %@ %@ says well not worse ", self.lastName, self.firstName);
    } else {
        NSLog(@"Bussinesman %@ %@ says it's a NOT good change", self.lastName, self.firstName);
    }
    self.income = newIncome;
}

- (void) averagePriceChangeNotification:(NSNotification*)notification {
    
}

- (void) appWillResignActiveNotification: (UIApplication*) application {
    NSLog(@"Bussinesman will go to sleep");
}

- (void) appBecomeActiveNotification: (UIApplication*) application {
    NSLog(@"Bussinesman wakes up");
}

@end
