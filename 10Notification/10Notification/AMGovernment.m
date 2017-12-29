//
//  AMGovernment.m
//  10Notification
//
//  Created by Admin on 26.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import "AMGovernment.h"

NSString* const AMGovernmentTaxRateDidChange = @"AMGovernmentTaxRateDidChange ";
NSString* const AMGovernmentAveragePriceDidChange = @"AMGovernmentAveragePriceDidChange";
NSString* const AMGovernmentSalaryDidChange = @"AMGovernmentSalaryDidChange";
NSString* const AMGovernmentPensionDidChange = @"AMGovernmentPensionDidChange";
NSString* const AMGovernmentTaxRateUserInfoKey = @"AMGovernmentTaxRateUserInfoKey";
NSString* const AMGovernmentSalaryUserInfoKey = @"AMGovernmentSalaryUserInfoKey";
NSString* const AMGovernmentAveragePriceOldUserInfoKey = @"AMGovernmentAveragePriceOldUserInfoKey";
NSString* const AMGovernmentAveragePriceNewUserInfoKey = @"AMGovernmentAveragePriceNewUserInfoKey";
NSString* const AMGovernmentPensionUserInfoKey = @"AMGovernmentPensionUserInfoKey";

@implementation AMGovernment

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.taxRate = 12.f;
        self.salary = 819.25f;
        self.pension = 256.32f;
        self.averagePrice = 2.1f;
    }
    return self;
}

- (void) setTaxRate:(CGFloat)taxRate {
    NSDictionary* UserInfoKey = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:_taxRate] forKey:AMGovernmentTaxRateUserInfoKey];
    _taxRate = taxRate;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMGovernmentTaxRateDidChange object:nil
                                                      userInfo: UserInfoKey];
}

- (void) setAveragePrice:(CGFloat)averagePrice {
    NSDictionary* UserInfoKey = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:_averagePrice],AMGovernmentAveragePriceOldUserInfoKey,[NSNumber numberWithFloat:averagePrice],AMGovernmentAveragePriceNewUserInfoKey,nil];
    _averagePrice = averagePrice;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMGovernmentAveragePriceDidChange object:nil
                                                      userInfo: UserInfoKey];
    
}

- (void) setSalary:(CGFloat)salary {
    NSDictionary* UserInfoKey = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:_salary] forKey:AMGovernmentSalaryUserInfoKey];
    _salary = salary;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMGovernmentSalaryDidChange object:nil
                                                      userInfo: UserInfoKey];
}

- (void) setPension:(CGFloat)pension {
    NSDictionary* UserInfoKey = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:_pension] forKey:AMGovernmentPensionUserInfoKey];
    _pension = pension;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMGovernmentPensionDidChange object:nil
                                                      userInfo: UserInfoKey];
}

- (void) changeTaxRate {
    if (arc4random() % 2) {
        self.taxRate += (CGFloat)(arc4random() % 20 + 1) / 10;
    } else {
        self.taxRate = self.taxRate - (CGFloat)(arc4random() % 20 + 1) / 10;
    }
}

- (void) changeSalary {
    if (arc4random() % 2) {
        self.salary += (CGFloat)(arc4random() % 5 + 1) * 100;
    } else {
        self.salary = self.salary - (CGFloat)(arc4random() % 5 + 1) * 100;
    }
}

- (void) changePension {
    if (arc4random() % 2) {
        self.pension += (CGFloat)(arc4random() % 10 + 1) * 10;
    } else {
        self.pension = self.pension - (CGFloat)(arc4random() % 10 + 1) * 10;
    }
}

- (void) changeAveragePrice {
    if (arc4random() % 2) {
        self.averagePrice += (CGFloat)(arc4random() % 10 + 1) / 10;
    } else {
        self.averagePrice = self.averagePrice - (CGFloat)(arc4random() % 10 + 1) / 10;
    }
}

@end
