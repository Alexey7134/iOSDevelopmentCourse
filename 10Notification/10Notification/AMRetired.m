//
//  AMRetired.m
//  10Notification
//
//  Created by Admin on 27.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMRetired.h"
#import "AMGovernment.h"

@implementation AMRetired

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pensionChangeNotification:) name:AMGovernmentPensionDidChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(averagePriceChangeNotification:) name:AMGovernmentAveragePriceDidChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) pensionChangeNotification:(NSNotification*)notification {
    CGFloat newPension = [[notification.userInfo objectForKey:AMGovernmentPensionUserInfoKey] floatValue];
    CGFloat increaseIncome = newPension - self.pension;
    if (increaseIncome > 0 && self.inflation <= 0) {
        NSLog(@"Retired is very satisfied");
    } else if (increaseIncome > 0 && increaseIncome > self.inflation) {
        NSLog(@"Retired is not bad");
    } else {
        NSLog(@"Retired is very not satisfied");
    }
    self.pension = newPension;
}

- (void) averagePriceChangeNotification:(NSNotification*)notification {
    CGFloat oldAveragePrice = [[notification.userInfo objectForKey:AMGovernmentAveragePriceOldUserInfoKey] floatValue];
    CGFloat newAveragePrice = [[notification.userInfo objectForKey:AMGovernmentAveragePriceNewUserInfoKey] floatValue];
    CGFloat inflation = (CGFloat)(newAveragePrice - oldAveragePrice) / 100;
    if (inflation > 0) {
        NSLog(@"Again the prices were raised :( ");
    }
    self.inflation = inflation;
}

- (void) appWillResignActiveNotification: (UIApplication*) application {
    NSLog(@"Retired will go to sleep");
}

- (void) appBecomeActiveNotification: (UIApplication*) application {
    NSLog(@"Retired wakes up");
}

@end
