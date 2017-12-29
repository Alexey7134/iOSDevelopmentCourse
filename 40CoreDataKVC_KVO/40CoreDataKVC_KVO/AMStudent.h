//
//  AMStudent.h
//  40CoreDataKVC_KVO
//
//  Created by Admin on 02.11.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AMGenderType) {
    AMGenderTypeMan = 0,
    AMGenderTypeWoman = 1
};

@interface AMStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSDate* dateOfBirth;
@property (assign, nonatomic) AMGenderType gender;
@property (assign, nonatomic) float grade;
@property (weak, nonatomic) AMStudent* bestFriend;

+ (AMStudent*) randomStudent;

- (void) resetValueForProperties;

@end
