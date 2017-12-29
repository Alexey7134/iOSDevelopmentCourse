//
//  AMStudent.h
//  35UITableViewSearch
//
//  Created by Admin on 17.10.17.
//  Copyright © 2017 Anna Miksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSDate* dateOfBirth;

+ (AMStudent*) randomStudent;

@end
