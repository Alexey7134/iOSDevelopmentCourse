//
//  AMUser.h
//  45ClientServerAPIBasic
//
//  Created by Admin on 03.12.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMServerObject.h"

@interface AMUser : AMServerObject

@property (assign, nonatomic) long userID;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSDate* dateOfBirth;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSURL* photo50;
@property (strong, nonatomic) NSURL* photo200;

@end
