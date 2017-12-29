//
//  AMGovernment.h
//  10Notification
//
//  Created by Admin on 26.08.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

extern NSString* const AMGovernmentTaxRateDidChange;
extern NSString* const AMGovernmentAveragePriceDidChange;
extern NSString* const AMGovernmentSalaryDidChange;
extern NSString* const AMGovernmentPensionDidChange;
extern NSString* const AMGovernmentTaxRateUserInfoKey;
extern NSString* const AMGovernmentAveragePriceOldUserInfoKey;
extern NSString* const AMGovernmentAveragePriceNewUserInfoKey;
extern NSString* const AMGovernmentSalaryUserInfoKey;
extern NSString* const AMGovernmentPensionUserInfoKey;

@interface AMGovernment : NSObject

@property (assign, nonatomic) CGFloat taxRate;
@property (assign, nonatomic) CGFloat averagePrice;
@property (assign, nonatomic) CGFloat salary;
@property (assign, nonatomic) CGFloat pension;

- (void) changeTaxRate;
- (void) changeSalary;
- (void) changePension;
- (void) changeAveragePrice;

@end
